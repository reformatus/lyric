import 'dart:convert';

import 'package:drift/drift.dart';

import '../bank/bank.dart';
import '../database.dart';

class Song extends Insertable<Song> {
  final String uuid;
  final String? sourceBank;
  final String title;
  final String opensong;
  final KeyField? keyField;
  final String? composer;
  final String? lyricist;
  final String? translator;

  Map<String, String> contentMap;
  String? userNote;

  factory Song.fromBankApiJson(Map<String, dynamic> json, {Bank? sourceBank}) {
    try {
      if (!mandatoryFields.every((field) => json.containsKey(field))) {
        throw Exception(
          'Missing mandatory fields in: ${json['title']} (${json['uuid']})',
        );
      }

      return Song(
        uuid: json['uuid'],
        title: json['title'],
        opensong: json['opensong'],
        keyField: KeyField.fromString(json['key']),
        contentMap: json.map((key, value) => MapEntry(key, value.toString())),
        sourceBank: sourceBank?.uuid,
        composer: json['composer'],
        lyricist: json['lyricist'],
        translator: json['translator'],
      );
    } catch (e) {
      throw Exception(
        'Invalid song data in: ${json['title']} (${json['uuid']})\nError: $e',
      );
    }
  }

  Song({
    required this.uuid,
    required this.title,
    required this.opensong,
    required this.keyField,
    required this.contentMap,
    this.sourceBank,
    this.composer,
    this.lyricist,
    this.translator,
    this.userNote,
  });

  String get firstLine {
    try {
      final lines = opensong.substring(0, 100).split('\n');
      return lines
          .firstWhere((e) => !e.startsWith('[') && !e.startsWith('.'))
          .trim()
          .replaceAll('_', '');
    } catch (_) {
      return '';
    }
  }

  int get contentHash => Object.hash(jsonEncode(contentMap), sourceBank);

  @override
  bool operator ==(Object other) {
    if (other is! Song) return false;
    return uuid == other.uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return SongsCompanion(
      uuid: Value(uuid),
      sourceBank: Value(sourceBank),
      contentMap: Value(contentMap),
      title: Value(title),
      opensong: Value(opensong),
      composer: Value(composer),
      lyricist: Value(lyricist),
      translator: Value(translator),
      keyField: Value(keyField),
      userNote: Value(userNote),
    ).toColumns(nullToAbsent);
  }
}

const List<String> mandatoryFields = ['uuid', 'title', 'opensong'];

@TableIndex(name: 'songs_uuid', columns: {#uuid}, unique: true)
@UseRowClass(Song)
class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  TextColumn get sourceBank => text().nullable().references(Banks, #uuid)();
  TextColumn get contentMap => text().map(const SongContentConverter())();
  TextColumn get title => text()();
  TextColumn get opensong => text()();
  TextColumn get composer => text().nullable()();
  TextColumn get lyricist => text().nullable()();
  TextColumn get translator => text().nullable()();
  TextColumn get keyField => text().map(const KeyFieldConverter())();
  TextColumn get userNote => text().nullable()();
}

class SongContentConverter extends TypeConverter<Map<String, String>, String> {
  const SongContentConverter();

  @override
  Map<String, String> fromSql(String fromDb) {
    return (jsonDecode(fromDb) as Map).cast<String, String>();
  }

  @override
  String toSql(Map<String, String> value) {
    return jsonEncode(value);
  }
}

class KeyFieldConverter extends TypeConverter<KeyField?, String> {
  const KeyFieldConverter();

  @override
  KeyField? fromSql(String fromDb) {
    return KeyField.fromString(fromDb);
  }

  @override
  String toSql(KeyField? value) {
    if (value == null) return "";
    return value.toString();
  }
}

class KeyField {
  final String pitch;
  final String mode;

  KeyField(this.pitch, this.mode);

  static KeyField? fromString(String? value) {
    if (value == null || value.isEmpty) return null;

    // TODO handle multiple keys with a key list
    value = value.split(', ').first;

    var parts = value.split('-');
    if (parts.length != 2) {
      throw Exception('Invalid key field: $value');
    }
    return KeyField(parts[0], parts[1]);
  }

  @override
  String toString() {
    return '$pitch-$mode';
  }

  @override
  bool operator ==(Object other) {
    if (other is! KeyField) return false;
    if (pitch == other.pitch && mode == other.mode) return true;
    return false;
  }

  @override
  int get hashCode => Object.hash(pitch, mode);
}

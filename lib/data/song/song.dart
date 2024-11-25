import 'dart:convert';

import 'package:drift/drift.dart';

import '../bank/bank.dart';
import '../database.dart';

class Song extends Insertable<Song> {
  final String uuid;
  final int? sourceBankId; // todo store bank uuid (planned) instead
  final String title;
  final String lyrics;
  final KeyField? keyField;
  final String? composer;
  final String? lyricist;
  final String? translator;

  Map<String, String> contentMap;
  String? userNote;

  factory Song.fromBankApiJson(Map<String, dynamic> json, {Bank? sourceBank}) {
    try {
      if (!mandatoryFields.every((field) => json.containsKey(field))) {
        throw Exception('Missing mandatory fields in: ${json['title']} (${json['uuid']})');
      }

      return Song(
        uuid: json['uuid'],
        title: json['title'],
        lyrics: json['lyrics'],
        keyField: KeyField.fromString(json['key']),
        contentMap: json.map((key, value) => MapEntry(key, value.toString())),
        sourceBankId: sourceBank?.id,
        composer: json['composer'],
        lyricist: json['lyricist'],
        translator: json['translator'],
      );
    } catch (e, s) {
      throw Exception('Invalid song data in: ${json['title']} (${json['uuid']})\nError: $e\n$s\n');
    }
  }

  Song({
    required this.uuid,
    required this.title,
    required this.lyrics,
    required this.keyField,
    required this.contentMap,
    this.sourceBankId,
    this.composer,
    this.lyricist,
    this.translator,
    this.userNote,
  });

  int get contentHash => Object.hash(
        jsonEncode(contentMap),
        sourceBankId,
        userNote,
      );

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return SongsCompanion(
      uuid: Value(uuid),
      sourceBankId: Value(sourceBankId),
      contentMap: Value(contentMap),
      title: Value(title),
      lyrics: Value(lyrics),
      composer: Value(composer),
      lyricist: Value(lyricist),
      translator: Value(translator),
      keyField: Value(keyField),
      userNote: Value(userNote),
    ).toColumns(nullToAbsent);
  }
}

const List<String> mandatoryFields = ['uuid', 'title', 'lyrics'];

@TableIndex(name: 'songs_uuid', columns: {#uuid}, unique: true)
@UseRowClass(Song)
class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  IntColumn get sourceBankId => integer().nullable().references(Banks, #id)();
  TextColumn get contentMap => text().map(const SongContentConverter())();
  TextColumn get title => text()();
  TextColumn get lyrics => text()();
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

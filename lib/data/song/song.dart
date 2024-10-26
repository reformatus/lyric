import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:lyric/data/database.dart';

import '../bank/bank.dart';

class Song extends Insertable<Song> {
  final String uuid;
  final int? sourceBankId;
  final String title;
  final String lyrics;
  final KeyField? keyField;
  final String? composer;
  final String? poet;
  final String? translator;

  Map<String, String> contentMap;
  String? userNote;

  factory Song.fromJson(Map<String, dynamic> json, {Bank? sourceBank}) {
    try {
      if (!mandatoryFields.every((field) => json.containsKey(field))) {
        throw Exception('Missing mandatory fields in: ${json['title']} (${json['uuid']})');
      }

      return Song(
        uuid: json['uuid'],
        title: json['title'],
        lyrics: json['lyrics'],
        keyField: KeyField.fromString(json['pitch']), // todo change to key once song bank gets updated
        contentMap: json.map((key, value) => MapEntry(key, value.toString())),
        sourceBankId: sourceBank?.id,
        composer: json['composer'],
        poet: json['poet'],
        translator: json['translator'],
        userNote: json['user_note'], // todo will this be here? for example, when reading from file?
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
    this.poet,
    this.translator,
    this.userNote,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return SongsCompanion(
      uuid: Value(uuid),
      sourceBankId: Value(sourceBankId),
      contentMap: Value(contentMap),
      title: Value(title),
      lyrics: Value(lyrics),
      composer: Value(composer),
      poet: Value(poet),
      translator: Value(translator),
      keyField: Value(keyField),
      userNote: Value(userNote),
    ).toColumns(nullToAbsent);
  }
}

const List<String> mandatoryFields = ['uuid', 'title', 'lyrics'];

@UseRowClass(Song)
class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  IntColumn get sourceBankId => integer().nullable().references(Banks, #id)();
  TextColumn get contentMap => text().map(const ContentConverter())();
  TextColumn get title => text()();
  TextColumn get lyrics => text()();
  TextColumn get composer => text().nullable()();
  TextColumn get poet => text().nullable()();
  TextColumn get translator => text().nullable()();
  TextColumn get keyField => text().map(const KeyFieldConverter())();
  TextColumn get userNote => text().nullable()();
}

class ContentConverter extends TypeConverter<Map<String, String>, String> {
  const ContentConverter();

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
  final String key;
  final String scale;

  KeyField(this.key, this.scale);

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
    return '$key-$scale';
  }
}

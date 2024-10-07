import 'dart:convert';

import 'package:drift/drift.dart';

class Song {
  final String uuid;
  final Uri source;
  final String title;
  final String lyrics;
  final PitchField pitchField;
  Map<String, String> content;
  String? userNote;

  factory Song.fromJson(Map<String, dynamic> json, {required Uri source}) {
    try {
      if (!mandatoryFields.every((field) => json.containsKey(field))) {
        throw Exception('Missing mandatory fields in: ${json['title']} (${json['uuid']})');
      }

      return Song(
        json['uuid'],
        source,
        json['title'],
        json['lyrics'],
        PitchField.fromString(json['pitchField']),
        json.map((key, value) => MapEntry(key, value.toString())),
      );
    } catch (e) {
      throw Exception('Invalid song data in: ${json['title']} (${json['uuid']})\nError: $e');
    }
  }

  Song(this.uuid, this.source, this.title, this.lyrics, this.pitchField, this.content);
}

const List<String> mandatoryFields = ['title', 'lyrics'];

@UseRowClass(Song)
class Songs extends Table {
  TextColumn get uuid => text()();
  TextColumn get source => text().map(const UriConverter())();
  TextColumn get title => text()();
  TextColumn get lyrics => text()();
  TextColumn get pitchField => text().map(const PitchFieldConverter())();
  TextColumn get content => text().map(const ContentConverter())();
  TextColumn get userNote => text().nullable()();

  @override
  Set<Column> get primaryKey => {uuid};
}

class ContentConverter extends TypeConverter<Map<String, String>, String> {
  const ContentConverter();

  @override
  Map<String, String> fromSql(String fromDb) {
    return jsonDecode(fromDb) as Map<String, String>;
  }

  @override
  String toSql(Map<String, String> value) {
    return jsonEncode(value);
  }
}

class UriConverter extends TypeConverter<Uri, String> {
  const UriConverter();

  @override
  Uri fromSql(String fromDb) {
    return Uri.parse(fromDb);
  }

  @override
  String toSql(Uri value) {
    return value.toString();
  }
}

class PitchFieldConverter extends TypeConverter<PitchField, String> {
  const PitchFieldConverter();

  @override
  PitchField fromSql(String fromDb) {
    return PitchField.fromString(fromDb);
  }

  @override
  String toSql(PitchField value) {
    return value.toString();
  }
}

class PitchField {
  final String key;
  final String scale;

  PitchField(this.key, this.scale);

  factory PitchField.fromString(String value) {
    throw UnimplementedError(); // todo
  }

  @override
  String toString() {
    throw UnimplementedError(); // todo
  }
}

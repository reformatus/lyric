import 'dart:convert';

import 'package:drift/drift.dart';

import '../database.dart';
import 'slide.dart';

/*
  far future todo: self-hostable cue collaboration platforms
  far future todo: local network cue collaboration
 */

const currentCueVersion = 1;

@UseRowClass(Cue)
@TableIndex(name: 'cues_uuid', columns: {#uuid}, unique: true)
class Cues extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get cueVersion => integer()();

  TextColumn get content => text().map(const CueContentConverter())();
}

class Cue extends Insertable<Cue> {
  final int id;
  final String uuid;
  String title;
  String description;
  int cueVersion;

  List<Map> content;

  Future<List<Slide>> getRevivedSlides() async {
    return await Future.wait(content.map((e) => Slide.reviveFromJson(e, this)));
  }

  static List<Map> getContentMapFromSlides(List<Slide> slides) {
    return slides.map((s) => s.toJson()).toList();
  }

  Cue(
    this.id,
    this.uuid,
    this.title,
    this.description,
    this.cueVersion,
    this.content,
  );

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return CuesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      title: Value(title),
      description: Value(description),
      cueVersion: Value(cueVersion),
      content: Value(content),
    ).toColumns(nullToAbsent);
  }

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "title": title,
      "description": description,
      "cueVersion": cueVersion,
      "content": content,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cue && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}

class CueContentConverter extends TypeConverter<List<Map>, String> {
  const CueContentConverter();

  @override
  List<Map> fromSql(String fromDb) {
    return (jsonDecode(fromDb) as List).cast<Map>();
  }

  @override
  String toSql(List<Map> value) {
    return jsonEncode(value);
  }
}

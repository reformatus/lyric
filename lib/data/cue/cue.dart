import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'slide.dart';

part 'cue.g.dart';

@UseRowClass(Cue)
class Cues extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get cueVersion => integer()();

  TextColumn get content => text().map(const CueContentConverter())();
}

class Cue extends Insertable<Cue> {
  final int id;
  String title;
  String description;
  int cueVersion;

  List<Map> content;

  List<Slide>? slides;

  Future reviveSlides() async {
    slides = await Future.wait(content.map((e) => Slide.reviveFromJson(e)));
    return;
  }

  Cue(
    this.id,
    this.title,
    this.description,
    this.cueVersion,
    this.content,
  );

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return CuesCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      cueVersion: Value(cueVersion),
      content: Value(content),
    ).toColumns(nullToAbsent);
  }
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

@riverpod
Future reviveSlidesForCue(Ref ref, Cue cue) async {
  return await cue.reviveSlides();
}

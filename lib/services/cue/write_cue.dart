import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/v4.dart';

import '../../data/cue/cue.dart';
import '../../data/cue/slide.dart';
import '../../data/database.dart';

part 'write_cue.g.dart';

@riverpod
Future insertNewCue(Ref ref, {required String title, String? description}) async {
  await db.into(db.cues).insert(
        CuesCompanion(
          id: Value.absent(),
          uuid: Value(UuidV4().generate()),
          title: Value(title),
          description: description != null ? Value(description) : Value.absent(),
          cueVersion: Value(currentCueVersion),
          content: Value([]),
        ),
      );
}

@riverpod
Future updateCueMetadataFor(Ref ref, int id, {String? title, String? description}) async {
  await (db.update(db.cues)..where((c) => c.id.equals(id))).write(
    CuesCompanion(
      title: Value.absentIfNull(title),
      description: Value.absentIfNull(description),
    ),
  );
}

@riverpod
Future updateSlidesOfCue(Ref ref, Cue cue) async {
  //cue.updateContentJson();

  throw UnimplementedError();
}

/*
@riverpod
Future updateCueWith(Ref ref, int id, CuesCompanion data) async {
  await (db.update(db.cues)..where((e) => e.id.equals(id))).write(data);
}
*/

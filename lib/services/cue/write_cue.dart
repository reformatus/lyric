import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/v4.dart';

import '../../data/cue/cue.dart';
import '../../data/database.dart';

Future<Cue> insertNewCue({required String title, required String description}) async {
  return await db.into(db.cues).insertReturning(
        CuesCompanion(
          id: Value.absent(),
          uuid: Value(UuidV4().generate()),
          title: Value(title),
          description: Value(description),
          cueVersion: Value(currentCueVersion),
          content: Value([]),
        ),
      );
}

Future updateCueMetadataFor(int id, {String? title, String? description}) async {
  await (db.update(db.cues)..where((c) => c.id.equals(id))).write(
    CuesCompanion(
      title: Value.absentIfNull(title),
      description: Value.absentIfNull(description),
    ),
  );
}

Future deleteCueWithUuid(String uuid) {
  return db.cues.deleteWhere((c) => c.uuid.equals(uuid));
}

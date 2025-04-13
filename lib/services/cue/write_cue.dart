import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/services/cue/slide/revived_slides.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/v4.dart';

import '../../data/cue/cue.dart';
import '../../data/cue/slide.dart';
import '../../data/database.dart';

part 'write_cue.g.dart';

Future<Cue> insertNewCue({required String title, required String description}) {
  return db
      .into(db.cues)
      .insertReturning(
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

Future updateCueMetadataFor(int id, {String? title, String? description}) {
  // todo use uuid
  return (db.update(db.cues)..where((c) => c.id.equals(id))).write(
    CuesCompanion(
      title: Value.absentIfNull(title),
      description: Value.absentIfNull(description),
    ),
  );
}

// Needs to be riverpod to invalidate revived slides (far future todo maybe refactor?)
@riverpod
Future removeSlideFromCue(Ref ref, Slide slide, Cue cue) async {
  await (db.update(db.cues)..where((c) => c.uuid.equals(cue.uuid))).write(
    CuesCompanion(
      content: Value(cue.content.where((s) => s['uuid'] != slide.uuid).toList()),
    ),
  );
  ref.invalidate(revivedSlidesForCueProvider(cue));
  return;
}

Future reorderCueSlides(Cue cue, int from, int to) {
  List<Map> updatedContent = List.from(cue.content);
  final item = updatedContent.removeAt(from);
  updatedContent.insert(to > from ? to - 1 : to, item);
  return (db.update(db.cues)..where(
    (c) => c.uuid.equals(cue.uuid),
  )).write(CuesCompanion(content: Value(updatedContent)));
}

Future deleteCueWithUuid(String uuid) {
  return db.cues.deleteWhere((c) => c.uuid.equals(uuid));
}

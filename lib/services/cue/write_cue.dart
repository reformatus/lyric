import 'package:drift/drift.dart';
import 'package:uuid/v4.dart';

import '../../data/cue/cue.dart';
import '../../data/cue/slide.dart';
import '../../data/database.dart';

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

Future<Cue> insertCueFromJson({required Map json}) {
  return db
      .into(db.cues)
      .insertReturning(
        CuesCompanion(
          id: Value.absent(),
          uuid: Value(json["uuid"]),
          title: Value(json["title"]),
          description: Value(json["description"]),
          cueVersion: Value(json["cueVersion"]),
          content: Value(
            (json["content"] as List).map((e) => e as Map).toList(),
          ),
        ),
      );
}

Future<Cue> updateCueFromJson({required Map json}) async {
  return (await (db.update(
        db.cues,
      )..where((c) => c.uuid.equals(json["uuid"]))).writeReturning(
        CuesCompanion(
          title: Value(json["title"]),
          description: Value(json["description"]),
          cueVersion: Value(json["cueVersion"]),
          content: Value(
            (json["content"] as List).map((e) => e as Map).toList(),
          ),
        ),
      ))
      .first;
}

Future updateCueMetadata(Cue cue, {String? title, String? description}) {
  return (db.update(db.cues)..where((c) => c.id.equals(cue.id))).write(
    CuesCompanion(
      title: Value.absentIfNull(title),
      description: Value.absentIfNull(description),
    ),
  );
}

/// Normally updates DB to match current object's state.
/// When supplied with `slides`, content gets overwritten.
Future updateCueSlides(Cue cue, [List<Slide>? slides]) async {
  if (slides != null) {
    cue.content = Cue.getContentMapFromSlides(slides);
  }

  await (db.update(db.cues)..where((c) => c.uuid.equals(cue.uuid))).write(
    CuesCompanion(content: Value(cue.content)),
  );
}

Future addSlideToCue(Slide slide, Cue cue, {int? atIndex}) async {
  cue.content.insert(atIndex ?? cue.content.length, slide.toJson());
  await updateCueSlides(cue);
}

Future deleteCueWithUuid(String uuid) {
  return db.cues.deleteWhere((c) => c.uuid.equals(uuid));
}

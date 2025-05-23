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
          uuid: json["uuid"],
          title: json["title"],
          description: json["description"],
          cueVersion: json["cueVersion"],
          content: json["content"],
        ),
      );
}

Future updateCueMetadata(Cue cue, {String? title, String? description}) {
  return (db.update(db.cues)..where((c) => c.id.equals(cue.id))).write(
    CuesCompanion(
      title: Value.absentIfNull(title),
      description: Value.absentIfNull(description),
    ),
  );
}

Future updateCueSlides(Cue cue, List<Slide> slides) async {
  await (db.update(db.cues)..where(
    (c) => c.uuid.equals(cue.uuid),
  )).write(CuesCompanion(content: Value(Cue.getContentMapFromSlides(slides))));
}

Future deleteCueWithUuid(String uuid) {
  return db.cues.deleteWhere((c) => c.uuid.equals(uuid));
}

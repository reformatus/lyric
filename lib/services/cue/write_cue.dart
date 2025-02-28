import 'package:drift/drift.dart';
import 'package:uuid/v4.dart';

import '../../data/cue/cue.dart';
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

Future updateCueMetadataFor(int id, {String? title, String? description}) {
  // todo use uuid
  return (db.update(db.cues)..where((c) => c.id.equals(id))).write(
    CuesCompanion(
      title: Value.absentIfNull(title),
      description: Value.absentIfNull(description),
    ),
  );
}

Future removeSlideAtIndexFromCue(int index, Cue cue) {
  return (db.update(db.cues)..where((c) => c.uuid.equals(cue.uuid))).write(
    CuesCompanion(
      content: Value(
        cue.content
            .asMap()
            .entries
            .where((e) => e.key != index)
            .map((e) => e.value)
            .toList(),
      ),
    ),
  );
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

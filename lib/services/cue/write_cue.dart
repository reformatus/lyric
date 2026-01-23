import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/v4.dart';

import '../../data/cue/cue.dart';
import '../../data/cue/slide.dart';
import '../../data/database.dart';
import '../../ui/cue/session/session_provider.dart';

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
///
/// NOTE: When working with the active cue session, prefer using
/// ActiveCueSession.updateSlide/addSlide/etc. which handle debouncing.
/// This function is for direct DB writes (e.g., from session provider).
Future updateCueSlides(Cue cue, [List<Slide>? slides]) async {
  if (slides != null) {
    cue.content = Cue.getContentMapFromSlides(slides);
  }

  await (db.update(db.cues)..where((c) => c.uuid.equals(cue.uuid))).write(
    CuesCompanion(content: Value(cue.content)),
  );
}

/// Add slide to a cue.
///
/// Routes through session if cue is currently active (for proper state management
/// and debounced writes). Otherwise writes directly to DB.
///
/// [ref] is required to check if the cue is active in the session.
Future<void> addSlideToCue(
  Slide slide,
  Cue cue, {
  int? atIndex,
  required WidgetRef ref,
}) async {
  final session = ref.read(activeCueSessionProvider).value;

  if (session != null && session.cue.uuid == cue.uuid) {
    // Active cue: route through session (gets debounced write + UI update)
    ref
        .read(activeCueSessionProvider.notifier)
        .addSlide(slide, atIndex: atIndex);
  } else {
    // Inactive cue: direct DB write
    cue.content.insert(atIndex ?? cue.content.length, slide.toJson());
    await updateCueSlides(cue);
  }
}

Future deleteCueWithUuid(String uuid) {
  return db.cues.deleteWhere((c) => c.uuid.equals(uuid));
}

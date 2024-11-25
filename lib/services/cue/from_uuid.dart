import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/cue.dart';
import '../../data/database.dart';

part 'from_uuid.g.dart';

@riverpod
Stream<Cue> watchCueWithUuid(Ref ref, String uuid) async* {
  await for (Cue cue in (db.cues.select()..where((c) => c.uuid.equals(uuid))).watchSingle()) {
    await cue.getRevivedSlides();
    yield cue;
  }
}

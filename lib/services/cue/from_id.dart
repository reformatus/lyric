import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/cue.dart';

part 'from_id.g.dart';

@riverpod
Stream<Cue> watchAndReviveCueWithId(Ref ref, int id) async* {
  await for (Cue cue in (db.cues.select()..where((c) => c.id.equals(id))).watchSingle()) {
    await cue.reviveSlides();
    yield cue;
  }
}

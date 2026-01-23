import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/cue.dart';
import '../../data/database.dart';

part 'cues.g.dart';

//! watchAllCues

@Riverpod(keepAlive: true)
Stream<List<Cue>> watchAllCues(Ref ref) async* {
  yield* dbWatchAllCues();
}

Stream<List<Cue>> dbWatchAllCues() async* {
  yield* ((db.cues.select().watch()));
}

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/cue.dart';

part 'cues.g.dart';

//! watchAllCues

@riverpod
Stream<List<Cue>> watchAllCues(Ref ref) async* {
  yield* dbWatchAllCues();
}

Stream<List<Cue>> dbWatchAllCues() async* {
  yield* ((db.cues.select().watch()));
}
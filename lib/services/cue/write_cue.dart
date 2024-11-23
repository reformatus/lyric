import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/cue.dart';
import '../../data/database.dart';

part 'write_cue.g.dart';

//! insertNewCue

/// Returns generated id
Future<int> dbInsertNewCue(NewCue newCue) async {
  return db.into(db.cues).insert(Cue.newCueToCompanion(newCue));
}

@riverpod
Future insertNewCue(Ref ref, NewCue newCue) async {
  // we ignore generated id
  await dbInsertNewCue(newCue);
}

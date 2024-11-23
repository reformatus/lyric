import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/cue.dart';

part 'cues.g.dart';

@riverpod
Future<List<Cue>> getAllCues(Ref ref) async {
  return await dbGetAllCues();
}

Future<List<Cue>> dbGetAllCues() async {
  return await ((db.cues.select().get()));
}

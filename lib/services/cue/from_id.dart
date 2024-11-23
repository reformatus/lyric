import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/cue.dart';

part 'from_id.g.dart';

@riverpod
Future<Cue> revivedCueFromId(Ref ref, int id) async {
  final cue = await dbCueFromId(id);
  await cue.reviveSlides();
  return cue;
}

Future<Cue> dbCueFromId(int id) async {
  return await (db.cues.select()..where((c) => c.id.equals(id))).getSingle();
}

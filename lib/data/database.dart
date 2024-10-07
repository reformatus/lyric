import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'song/song.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Songs])
class LyricDatabase extends _$LyricDatabase {
  LyricDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'lyric');
  }
}

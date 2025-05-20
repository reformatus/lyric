import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../cue.dart';

part 'database.g.dart';

@DriftDatabase(
  // far future todo include songs and assets to import when opening file for offline/custom songs.
  tables: [Cues],
)
class CueFileDatabase extends _$CueFileDatabase {
  File cueFile;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
    );
  }

  CueFileDatabase(this.cueFile) : super(_openConnection(cueFile));
}

LazyDatabase _openConnection(File file) {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    return NativeDatabase.createInBackground(file);
  });
}

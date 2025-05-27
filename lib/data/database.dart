import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:path/path.dart' as p;

import 'bank/bank.dart';
import 'cue/cue.dart';
import 'song/song.dart';
import 'asset/asset.dart';

part 'database.g.dart';

late LyricDatabase db;
late final Directory dataDir;

@DriftDatabase(
  tables: [Songs, Banks, Assets, Cues],
  include: {
    'song/song.drift',
    '../services/songs/filter.drift',
    '../services/key/select_distinct.drift',
  },
)
class LyricDatabase extends _$LyricDatabase {
  // LyricDatabase() : super(_openConnection()); //used for debugging
  LyricDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        for (var bank in defaultBanks) {
          await into(banks).insert(bank);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'lyric');
  }
}

/*
// see https://drift.simonbinder.eu/setup/#database-class
// implemented for logStatemets capability, used for debugging
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lyric.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file, logStatements: false);
  });
}
*/
class UriConverter extends TypeConverter<Uri, String> {
  const UriConverter();

  @override
  Uri fromSql(String fromDb) {
    return Uri.parse(fromDb);
  }

  @override
  String toSql(Uri value) {
    return value.toString();
  }
}

String sanitize(String s) =>
    s.replaceAll(RegExp(r'[^\p{Letter}\p{Number} ]', unicode: true), '');

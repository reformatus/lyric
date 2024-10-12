import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'bank/bank.dart';
import 'song/song.dart';

part 'database.g.dart';

late LyricDatabase db;
late final Directory dataDir;

@DriftDatabase(tables: [Songs, Banks])
class LyricDatabase extends _$LyricDatabase {
  LyricDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'lyric');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      await m.createAll();
      for (var bank in defaultBanks) {
        await into(banks).insert(bank);
      }
    });
  }
}

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

String sanitize(String s) => s.replaceAll(RegExp(r'[^\p{Letter}\p{Number} ]', unicode: true), '');

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/bank/bank.dart';
import '../../data/database.dart';

part 'banks.g.dart';

@Riverpod(keepAlive: true)
Stream<List<Bank>> watchAllBanks(Ref ref) async* {
  yield* dbWatchAllBanks();
}

Stream<List<Bank>> dbWatchAllBanks() async* {
  yield* (db.banks.select().watch());
}

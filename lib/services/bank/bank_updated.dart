import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/bank/bank.dart';
import '../../data/database.dart';

part 'bank_updated.g.dart';

Future setAsUpdatedNow(Bank bank) {
  return (db.banks.update()..where((b) => b.id.equals(bank.id))).write(BanksCompanion(
    lastUpdated: Value(DateTime.now()),
  ));
}

@Riverpod(keepAlive: true)
Future<bool> hasEverUpdatedAnything(Ref ref) async {
  return (await (db.banks.select()..where((b) => b.lastUpdated.isNotNull())).get()).isNotEmpty;
}

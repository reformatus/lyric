import 'package:drift/drift.dart';
import 'package:lyric/data/database.dart';

import '../../data/bank/bank.dart';

Future setAsUpdatedNow(Bank bank) {
  return (db.banks.update()..where((b) => b.id.equals(bank.id))).write(BanksCompanion(
    lastUpdated: Value(DateTime.now()),
  ));
}

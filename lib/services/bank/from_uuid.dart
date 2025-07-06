import 'package:drift/drift.dart';
import '../../data/database.dart';

import '../../data/bank/bank.dart';

Stream<Bank?> dbWatchBankWithUuid(String uuid) async* {
  yield* (db.banks.select()..where((b) => b.uuid.equals(uuid)))
      .watchSingleOrNull();
}

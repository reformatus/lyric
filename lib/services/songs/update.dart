import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/log/logger.dart';
import 'package:queue/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/bank/bank.dart';
import '../../data/database.dart';
import '../../data/song/song.dart';
import '../bank/bank_updated.dart';

part 'update.g.dart';

bool isDone(({int toUpdateCount, int updatedCount})? record) {
  if (record == null) return false;
  return record.toUpdateCount == record.updatedCount;
}

double? getProgress(({int toUpdateCount, int updatedCount})? record) {
  if (record == null) return null;
  if (record.toUpdateCount == 0) return 1;
  return record.updatedCount / record.toUpdateCount;
}

@riverpod
Stream<Map<Bank, ({int toUpdateCount, int updatedCount})?>> updateAllBanks(
  Ref ref,
) async* {
  Map<Bank, ({int toUpdateCount, int updatedCount})?> bankStates =
      Map.fromEntries(
        (await (db.banks.select()..where((b) => b.isEnabled)).get()).map(
          (e) => MapEntry(e, null),
        ),
      );

  // copy to new instance to avoid it getting changed during ui
  yield {...bankStates};

  for (var bankState in bankStates.entries) {
    try {
      await for (var newState in updateBank(bankState.key)) {
        bankStates[bankState.key] = newState;
        yield {...bankStates};
      }
    } catch (e, s) {
      log.severe('Error while updating bank ${bankState.key.name}:', e, s);
    }
  }
}

Stream<({int toUpdateCount, int updatedCount})> updateBank(Bank bank) async* {
  // stay in indefinite loading state until we know protosong count
  // return protosong count for display
  List<ProtoSong> toUpdate = await bank.getProtoSongs(since: bank.lastUpdated);
  bool hadErrors = false;

  yield (toUpdateCount: toUpdate.length, updatedCount: 0);

  if (toUpdate.isNotEmpty) {
    final Queue queue = Queue(parallel: 10);
    for (var protoSong in toUpdate) {
      queue.add(() async {
        try {
          Song song = await bank.getSongDetails(protoSong.uuid);
          try {
            db
                .into(db.songs)
                .insert(
                  song,
                  mode: InsertMode.insertOrReplace,
                ); // todo handle user modified data, etc
          } catch (f, t) {
            hadErrors = true;
            log.severe(
              'Error while writing song ${protoSong.uuid} to database:',
              f,
              t,
            );
          }
        } catch (e, s) {
          hadErrors = true;
          log.severe(
            'Error while fetching details for song ${protoSong.uuid}:',
            e,
            s,
          );
        }
      });
    }

    await for (int remaining in queue.remainingItems) {
      yield (
        toUpdateCount: toUpdate.length,
        updatedCount: toUpdate.length - remaining,
      );
      if (remaining == 0) break;
    }
  }

  log.info('All songs updated for bank ${bank.name}');

  if (!hadErrors) await setAsUpdatedNow(bank);

  return;
}

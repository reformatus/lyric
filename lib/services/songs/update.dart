import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'delete_for_song.dart';
import '../../data/log/logger.dart';
import 'package:queue/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/bank/bank.dart';
import '../../data/database.dart';
import '../../data/song/song.dart';
import '../bank/bank_updated.dart';
import '../bank/update.dart';

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

/// Update all songs on all banks
@riverpod
Stream<Map<Bank, ({int toUpdateCount, int updatedCount})?>> updateAllBanksSongs(
  Ref ref,
) async* {
  await updateBanks();

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
      await for (var newState in updateBankSongs(bankState.key)) {
        bankStates[bankState.key] = newState;
        yield {...bankStates};
      }
    } catch (e, s) {
      log.severe('Hiba a ${bankState.key.name} frissítése közben:', e, s);
    }
  }
}

/// Update all songs in a bank
Stream<({int toUpdateCount, int updatedCount})> updateBankSongs(
  Bank bank,
) async* {
  // stay in indefinite loading state until we know protosong count
  // return protosong count for display
  List<ProtoSong> toUpdate;
  if (bank.noCms) {
    // when the bank static without cms, update all songs if there have been changes.
    final remoteLastUpdated = await bank.getRemoteLastUpdated();
    if (remoteLastUpdated != null &&
        bank.lastUpdated != null &&
        bank.lastUpdated!.isAfter(remoteLastUpdated)) {
      toUpdate = [];
    } else {
      toUpdate = await bank.getProtoSongs();
    }
  } else {
    toUpdate = await bank.getProtoSongs(since: bank.lastUpdated);
  }

  int updatedCount = 0;
  bool hadErrors = false;

  yield (toUpdateCount: toUpdate.length, updatedCount: 0);

  if (toUpdate.isNotEmpty) {
    final Queue queue = Queue(parallel: bank.parallelUpdateJobs);

    List<List<ProtoSong>> toUpdateBatches = [];
    for (var i = 0; i < toUpdate.length / bank.amountOfSongsInRequest; i++) {
      int startIndex = i * bank.amountOfSongsInRequest;
      int endIndex = min(
        (i + 1) * bank.amountOfSongsInRequest,
        toUpdate.length,
      );
      toUpdateBatches.add(toUpdate.sublist(startIndex, endIndex));
    }

    for (List<ProtoSong> protoSongs in toUpdateBatches) {
      queue.add(() async {
        try {
          List<Song>? songs;
          int retries = 0;
          do {
            try {
              songs = await bank.getDetailsForSongs(
                protoSongs.map((e) => e.uuid).toList(),
              );
            } catch (e) {
              if (retries > 5) {
                // Give up after 5 attempts
                rethrow;
              }
              retries++;
              log.info(
                '$protoSongs azonosítójú dalok részleteinek lekérdezésekor hiba lépett fel, újrapróbálkozás: ($retries / 5)',
              );
              await Future.delayed(const Duration(milliseconds: 500));
            }
          } while (songs == null);
          for (Song song in songs) {
            try {
              await db
                  .into(db.songs)
                  .insert(
                    song,
                    mode: InsertMode.insertOrReplace,
                  ); // todo handle user modified data, etc
              updatedCount++;
              deleteAssetsForSong(song);
            } catch (f, t) {
              hadErrors = true;
              log.severe(
                'Nem sikerült ${song.uuid} azonosítójú dal adatbázisba írása:',
                f,
                t,
              );
            }
          }
        } catch (e, s) {
          hadErrors = true;
          log.severe(
            '$protoSongs azonosítójú dalok lekérdezése sokadik próbálkozásra sem sikerült:',
            e,
            s,
          );
        }
      });
    }

    await for (int remaining in queue.remainingItems) {
      yield (toUpdateCount: toUpdate.length, updatedCount: updatedCount);
      if (remaining == 0) break;
    }

    await setAsUpdatedNow(bank);
  }

  if (!hadErrors) {
    log.info('Minden dal frissítve: ${bank.name}');
  } else {
    log.warning('Néhány dalt nem sikerült frissíteni: ${bank.name}');
  }

  return;
}

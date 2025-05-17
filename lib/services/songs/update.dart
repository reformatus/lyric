import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/services/songs/delete_for_song.dart';
import '../../data/log/logger.dart';
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
          int i = 0;
          do {
            try {
              songs = await bank.getDetailsForSongs(
                protoSongs.map((e) => e.uuid).toList(),
              );
            } catch (e) {
              if (i > 5) {
                // Give up after 5 attempts
                rethrow;
              }
              i++;
              log.info(
                'Error while fetching details for songs $protoSongs, retrying ($i / 5)',
              );
              await Future.delayed(const Duration(milliseconds: 500));
            }
          } while (songs == null);
          for (Song song in songs) {
            try {
              db
                  .into(db.songs)
                  .insert(
                    song,
                    mode: InsertMode.insertOrReplace,
                  ); // todo handle user modified data, etc
              deleteAssetsForSong(song);
            } catch (f, t) {
              hadErrors = true;
              log.severe(
                'Error while writing song ${song.uuid} to database:',
                f,
                t,
              );
            }
          }
        } catch (e, s) {
          hadErrors = true;
          log.severe(
            'Multiple errors while fetching details for songs $protoSongs, giving up:',
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

  if (!hadErrors) {
    await setAsUpdatedNow(bank);
    log.info('All songs updated for bank ${bank.name}');
  } else {
    log.warning('Some songs failed to update for bank ${bank.name}');
  }

  return;
}

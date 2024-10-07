import 'package:drift/drift.dart';
import 'package:lyric/data/database.dart';
import 'package:queue/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/bank/bank.dart';
import '../../data/song/song.dart';

part 'update.g.dart';

@riverpod
Stream<Map<Bank, ({int toUpdateCount, int updatedCount})?>> updateAllBanks(UpdateAllBanksRef ref) async* {
  Map<Bank, ({int toUpdateCount, int updatedCount})?> _bankStates = Map.fromEntries(
    (await db.banks.select().get()).map(
      (e) => MapEntry(e, null),
    ),
  );

  yield {..._bankStates}; // copy to new instance to avoid it getting changed during ui

  for (var bankState in _bankStates.entries) {
    await for (var newState in updateBank(bankState.key)) {
      _bankStates[bankState.key] = newState;
      yield {..._bankStates};
    }
  }
}

Stream<({int toUpdateCount, int updatedCount})> updateBank(Bank bank) async* {
  // stay in indefinite loading state until we know protosong count
  // return protosong count for display
  List<ProtoSong> protoSongs = await bank.getProtoSongs();
  Iterable<String> existingUuids = (await db.managers.songs.get()).map((song) => song.uuid);

  // todo instead supply last update date to api and get new/updated protosongs
  Iterable<ProtoSong> toUpdate = protoSongs.where((protoSong) => !existingUuids.contains(protoSong.uuid));

  yield (toUpdateCount: toUpdate.length, updatedCount: 0);

  final Queue queue = Queue(parallel: 10);
  for (var protoSong in toUpdate) {
    queue.add(() async {
      try {
        Song song = await bank.getSongDetails(protoSong.uuid);
        try {
          db
              .into(db.songs)
              .insert(song, mode: InsertMode.insertOrReplace); // todo handle user modified data, etc
        } catch (f) {
          print('Error while writing song ${protoSong.uuid} to database:\n$f');
        }
      } catch (e) {
        print('Error while fetching details for song ${protoSong.uuid}:\n$e'); // todo log/ui
      }
    });
  }

  await for (int remaining in queue.remainingItems) {
    yield (toUpdateCount: protoSongs.length, updatedCount: protoSongs.length - remaining);
  }
}

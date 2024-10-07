// ignore_for_file: provide_deprecation_message

import 'package:queue/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'bank.dart';

part 'provider.g.dart';

@deprecated
@riverpod
Future<List<ProtoSong>> protoSongList(ProtoSongListRef ref, Bank bank) async {
  return await bank.getProtoSongs();
}

@deprecated
@riverpod
Queue protoSongQueue(ProtoSongQueueRef ref, List<ProtoSong> protoSongs, Bank bank) {
  return bank.getProtoSongsQueue(protoSongs);
}

@deprecated
@riverpod
Stream<int?> remainingSongsCount(RemainingSongsCountRef ref, Queue? queue) async* {
  if (queue == null) {
    yield null;
  }

  await for (int i in queue!.remainingItems) {
    yield i;
  }
}

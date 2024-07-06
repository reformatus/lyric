//import 'package:queue/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'bank.dart';

part 'provider.g.dart';

@riverpod
Future<List<ProtoSong>> protoSongList(ProtoSongListRef ref, Bank bank) async {
  return await bank.getProtoSongs();
}
/*
@riverpod
Queue protoSongQueue(ProtoSongQueueRef ref, List<ProtoSong> protoSongs, Bank bank) {
  return bank.getProtoSongsQueue(protoSongs);
}
*/
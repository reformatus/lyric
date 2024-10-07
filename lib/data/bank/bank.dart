import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:queue/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../song/song.dart';

part 'bank.freezed.dart';
part 'bank.g.dart';

final Bank testBank = Bank('TESZT Sófár Kottatár', Uri.parse('https://kiskutyafule.csecsy.hu/api/'));
final Bank prodBank = Bank('Sófár Kottatár', Uri.parse('https://sofarkotta.csecsy.hu/api/'));

// todo make provider
final List<Bank> defaultBanks = [testBank, prodBank];

// todo depend on banks
@Riverpod(keepAlive: true)
Iterable<Song> allSongs(AllSongsRef ref) {
  return defaultBanks.expand((bank) => bank.songs);
}

class Bank {
  final Uri baseUrl;
  final String name;
  final Dio dio = Dio();

  List<Song> songs = [];

  Bank(this.name, this.baseUrl);

  Future<List<ProtoSong>> getProtoSongs() async {
    final resp = await dio.get('$baseUrl/songs');
    return (resp.data as List).map((e) => ProtoSong.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Song> getSongDetails(String uuid) async {
    Uri source = Uri.parse('$baseUrl/song/$uuid');
    final resp = await dio.getUri(source);
    try {
      var song = Song.fromJson(resp.data[0] as Map<String, dynamic>, source: source);
      return song;
    } catch (e) {
      throw Exception('Error while parsing song details for $uuid\n$e');
    }
  }

  Queue getProtoSongsQueue(List<ProtoSong> protoSongs) {
    final Queue queue = Queue(parallel: 10);
    for (var protoSong in protoSongs) {
      queue.add(() async {
        try {
          Song song = await getSongDetails(protoSong.uuid);
          songs.add(song);
        } catch (e) {
          // retry
          try {
            Song song = await getSongDetails(protoSong.uuid);
            songs.add(song);
          } catch (f) {
            print('Error while fetching song details for ${protoSong.uuid}\n$e'); // todo ui
          }
        }
      });
    }
    return queue;
  }

  //! Database
  // todo
}

@freezed
class ProtoSong with _$ProtoSong {
  factory ProtoSong(
    final String uuid,
    final String title,
  ) = _ProtoSong;

  factory ProtoSong.fromJson(Map<String, dynamic> json) => _$ProtoSongFromJson(json);
}

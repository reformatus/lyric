import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:queue/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database.dart';
import '../song/song.dart';

part 'bank.g.dart';
/*
final Bank testBank = Bank('TESZT Sófár Kottatár', Uri.parse('https://kiskutyafule.csecsy.hu/api/'));
final Bank prodBank = Bank('Sófár Kottatár', Uri.parse('https://sofarkotta.csecsy.hu/api/'));
*/

// todo make provider
@deprecated
final List<Bank> defaultBanks = []; //[testBank, prodBank];

// todo depend on banks
@deprecated
@Riverpod(keepAlive: true)
Iterable<Song> allSongs(AllSongsRef ref) {
  throw UnimplementedError();
  // todo return defaultBanks.expand((bank) => bank.songs);
}

/* todo
  banks extends table
  populate default banks
*/

// todo row class
class Bank {
  final int id;
  final Uri baseUrl;
  final String name;
  final Dio dio = Dio();

  @deprecated
  List<Song> songs = [];

  Bank(this.id, this.name, this.baseUrl);

  Future<List<ProtoSong>> getProtoSongs() async {
    final resp = await dio.get('$baseUrl/songs');
    return (resp.data as List).map((e) => ProtoSong.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Song> getSongDetails(String uuid) async {
    // todo handle unresponsive server/network and retries
    Uri source = Uri.parse('$baseUrl/song/$uuid');
    final resp = await dio.getUri(source);
    try {
      var song = Song.fromJson(resp.data[0] as Map<String, dynamic>, sourceBank: this);
      return song;
    } catch (e) {
      throw Exception('Error while parsing song details for $uuid\n$e');
    }
  }

  @deprecated
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
}

@UseRowClass(Bank)
class Banks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get baseUrl => text().map(const UriConverter())();
}

class ProtoSong {
  final String uuid;
  final String title;

  ProtoSong(this.uuid, this.title);

  factory ProtoSong.fromJson(Map<String, dynamic> json) =>
      ProtoSong(json['uuid'] as String, json['title'] as String);
}

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
//import 'package:path_provider/path_provider.dart';

import '../database.dart';
import '../song/song.dart';

// these get added to the database on first run
// todo add a way to add banks
final List<Bank> defaultBanks = [
  Bank(1, 'TESZT Sófár Kottatár', Uri.parse('https://kiskutyafule.csecsy.hu/api/')),
  Bank(2, 'Sófár Kottatár', Uri.parse('https://sofarkotta.csecsy.hu/api/')),
]; //[testBank, prodBank];

class Bank extends Insertable<Bank> {
  final int id;
  final Uri baseUrl;
  final String name;
  final Dio dio = Dio();

  @deprecated
  List<Song> songs = [];

  Bank(this.id, this.name, this.baseUrl);

  Future<List<ProtoSong>> getProtoSongs() async {
    await Future.delayed(Duration(seconds: 1)); // todo remove
    final resp = await dio.get('$baseUrl/songs');
    return (resp.data as List).map((e) => ProtoSong.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Song> getSongDetails(String uuid) async {
    // todo handle unresponsive server/network and retries
    await Future.delayed(Duration(milliseconds: 200)); // todo remove
    Uri source = Uri.parse('$baseUrl/song/$uuid');
    final resp = await dio.getUri(source);
    try {
      var song = Song.fromJson(resp.data[0] as Map<String, dynamic>, sourceBank: this);
      return song;
    } catch (e) {
      throw Exception('Error while parsing song details for $uuid\n$e');
    }
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return BanksCompanion(
      id: Value.absent(),
      name: Value(name),
      baseUrl: Value(baseUrl),
    ).toColumns(nullToAbsent);
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

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

//import 'package:path_provider/path_provider.dart';

import '../database.dart';
import '../song/song.dart';

/*
  far future todo: support bank discovery based on url
  baseUrl/discover => {
    name? description?
    supports lastUpdated? (is static?)
    available filter types?
  }
 */

/*
  far future todo: online bank discovery service
  api.lyricapp.org/banks => [...list of urls to autodiscover banks from]
  including name, description, metadata type, etc
  user can pick and choose
  banks can announce themselves (get added to community banks) (federation!)
  moderators can promote banks to officially endorsed
 */

// these get added to the database on first run
// todo add a way to add and disable banks
final List<Bank> defaultBanks = [
  /*Bank(1, 'TESZT Sófár Kottatár', Uri.parse('https://kiskutyafule.csecsy.hu/api/')),*/
  Bank(0, true, null, 'Sófár Kottatár', Uri.parse('https://sofarkotta.csecsy.hu/api/')),
  /*Bank(1, true, null, 'Református Énekeskönyv (1948)',
      Uri.parse('https://banks.lyricapp.org/reformatus-enekeskonyv/48/')),
  Bank(2, true, null, 'Református Énekeskönyv (2021)',
      Uri.parse('https://banks.lyricapp.org/reformatus-enekeskonyv/21/')),*/
];

class Bank extends Insertable<Bank> {
  final int id;
  // todo add global uuid (to support banks changing urls)
  bool isEnabled;
  DateTime? lastUpdated;
  // todo support static banks where lastUpdated is not used, only new songs are downloaded
  final Uri baseUrl;
  final String name;
  // todo add description
  final Dio dio = Dio();

  @deprecated
  List<Song> songs = [];

  Bank(
    this.id,
    this.isEnabled,
    this.lastUpdated,
    this.name,
    this.baseUrl,
  );

  Future<List<ProtoSong>> getProtoSongs({DateTime? since}) async {
    String url = '$baseUrl/songs';
    if (since != null) {
      String formattedDate = DateFormat('yyyy-MM-dd+HH:mm').format(since);
      url += '?c=$formattedDate';
    }
    final resp = await dio.get<String>(url);
    final jsonList = jsonDecode(resp.data ?? "[]") as List;

    return jsonList.map((e) => ProtoSong.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Song> getSongDetails(String uuid) async {
    // todo handle unresponsive server/network and retries
    Uri source = Uri.parse('$baseUrl/song/$uuid');
    final resp = await dio.getUri<String>(source);
    try {
      var songJson = jsonDecode(resp.data!);
      if (songJson is List) songJson = songJson.first; //make compatible with sófár kottatár quirk
      var song = Song.fromBankApiJson(songJson as Map<String, dynamic>, sourceBank: this);
      return song;
    } catch (e) {
      throw Exception('Error while parsing song details for $uuid\n$e');
    }
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return BanksCompanion(
      id: Value.absent(),
      isEnabled: Value(isEnabled),
      lastUpdated: Value(lastUpdated),
      name: Value(name),
      baseUrl: Value(baseUrl),
    ).toColumns(nullToAbsent);
  }
}

@UseRowClass(Bank)
class Banks extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isEnabled => boolean()();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
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

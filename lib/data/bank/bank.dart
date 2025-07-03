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
  /*Bank(
    0,
    true,
    2,
    10,
    null,
    'Sófár Kottatár',
    Uri.parse('https://sofarkotta.hu/api/'),
  ),*/
  /*Bank(1, true, null, 'Református Énekeskönyv (1948)',
      Uri.parse('https://banks.lyricapp.org/reformatus-enekeskonyv/48/')),
  Bank(2, true, null, 'Református Énekeskönyv (2021)',
      Uri.parse('https://banks.lyricapp.org/reformatus-enekeskonyv/21/')),*/
];

class Bank extends Insertable<Bank> {
  final int id;
  final String uuid;
  final Uint8List? logo;
  final Uint8List? tinyLogo;
  final String name;
  final String description;
  final String legal;
  final Uri baseUrl;
  final int parallelUpdateJobs;
  final int amountOfSongsInRequest;
  final bool noCms;
  final Map songFields;
  bool isEnabled;
  bool isOfflineMode;
  DateTime? lastUpdated;

  final Dio dio = Dio();

  Bank(
    this.id,
    this.uuid,
    this.logo,
    this.tinyLogo,
    this.name,
    this.description,
    this.legal,
    this.baseUrl,
    this.parallelUpdateJobs,
    this.amountOfSongsInRequest,
    this.noCms,
    this.songFields,
    this.isEnabled,
    this.isOfflineMode,
    this.lastUpdated,
  );

  Future<List<ProtoSong>> getProtoSongs({DateTime? since}) async {
    String url = '$baseUrl/songs';
    if (since != null) {
      String formattedDate = DateFormat('yyyy-MM-dd+HH:mm').format(since);
      url += '?c=$formattedDate';
    }
    final resp = await dio.get<String>(url);
    final jsonList = jsonDecode(resp.data ?? "[]") as List;

    return jsonList
        .map((e) => ProtoSong.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Song>> getDetailsForSongs(List<String> uuids) async {
    Uri source = Uri.parse('$baseUrl/song/${uuids.join(',')}');

    final resp = await dio.getUri<String>(source);
    try {
      var songsJson = jsonDecode(resp.data!);
      if (songsJson is List) {
        List<Song> songs = [];
        for (Map songJson in songsJson) {
          songs.add(
            Song.fromBankApiJson(
              songJson as Map<String, dynamic>,
              sourceBank: this,
            ),
          );
        }
        return songs;
      } else {
        var song = Song.fromBankApiJson(
          songsJson as Map<String, dynamic>,
          sourceBank: this,
        );
        return [song];
      }
    } catch (e) {
      throw Exception('Error while updating songs with uuids $uuids\n$e');
    }
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return BanksCompanion(
      id: Value.absent(),
      uuid: Value(uuid),
      logo: Value.absentIfNull(logo),
      tinyLogo: Value.absentIfNull(tinyLogo),
      name: Value(name),
      description: Value(description),
      legal: Value(legal),
      baseUrl: Value(baseUrl),
      parallelUpdateJobs: Value(parallelUpdateJobs),
      amountOfSongsInRequest: Value(amountOfSongsInRequest),
      noCms: Value(noCms),
      songFields: Value(songFields),
      isEnabled: Value(isEnabled),
      isOfflineMode: Value(isOfflineMode),
      lastUpdated: Value(lastUpdated),
    ).toColumns(nullToAbsent);
  }
}

@UseRowClass(Bank)
class Banks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  BlobColumn get logo => blob().nullable()();
  BlobColumn get tinyLogo => blob().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get legal => text()();
  TextColumn get baseUrl => text().map(const UriConverter())();
  IntColumn get parallelUpdateJobs => integer()();
  IntColumn get amountOfSongsInRequest => integer()();
  BoolColumn get noCms => boolean()();
  TextColumn get songFields => text().map(const MapConverter())();
  BoolColumn get isEnabled => boolean()();
  BoolColumn get isOfflineMode => boolean()();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
}

class MapConverter extends TypeConverter<Map, String> {
  const MapConverter();

  @override
  Map fromSql(String fromDb) {
    return jsonDecode(fromDb) as Map;
  }

  @override
  String toSql(Map value) {
    return jsonEncode(value);
  }
}

class ProtoSong {
  final String uuid;
  final String title;

  ProtoSong(this.uuid, this.title);

  factory ProtoSong.fromJson(Map<String, dynamic> json) =>
      ProtoSong(json['uuid'] as String, json['title'] as String);

  @override
  String toString() => '$title [$uuid]';
}

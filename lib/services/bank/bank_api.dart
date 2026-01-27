import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../data/bank/bank.dart';
import '../../data/song/song.dart';
import '../http/html_unescape.dart';

class BankApi {
  final Dio dio;

  const BankApi(this.dio);

  Future<List<ProtoSong>> getProtoSongs(Bank bank, {DateTime? since}) async {
    String url = '${bank.baseUrl}/songs';
    if (since != null) {
      String formattedDate = DateFormat('yyyy-MM-dd+HH:mm').format(since);
      url += '?c=$formattedDate';
    }
    final resp = await dio.get<String>(url);
    final jsonList = jsonDecode(resp.data ?? "[]") as List;

    return jsonList
        .map((e) => _unescapeProtoSongJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Song>> getDetailsForSongs(Bank bank, List<String> uuids) async {
    Uri source = Uri.parse('${bank.baseUrl}/song/${uuids.join(',')}');

    final resp = await dio.getUri<String>(source);
    try {
      var songsJson = jsonDecode(resp.data!);
      if (songsJson is List) {
        List<Song> songs = [];
        for (Map songJson in songsJson) {
          songs.add(
            Song.fromBankApiJson(
              _unescapeSongJson(songJson as Map<String, dynamic>),
              sourceBank: bank,
            ),
          );
        }
        return songs;
      } else {
        var song = Song.fromBankApiJson(
          _unescapeSongJson(songsJson as Map<String, dynamic>),
          sourceBank: bank,
        );
        return [song];
      }
    } catch (e) {
      throw Exception('Error while updating songs with uuids $uuids\n$e');
    }
  }

  Future<DateTime?> getRemoteLastUpdated(Bank bank) async {
    try {
      final resp = await dio.get<String>('${bank.baseUrl}/about');
      final jsonData = jsonDecode(resp.data ?? "{}") as Map<String, dynamic>;

      if (jsonData.containsKey('lastUpdated')) {
        return DateTime.parse(jsonData['lastUpdated'] as String);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _unescapeSongJson(Map<String, dynamic> json) {
    return unescapeHtmlMap(json);
  }

  ProtoSong _unescapeProtoSongJson(Map<String, dynamic> json) {
    return ProtoSong(
      json['uuid'] as String,
      unescapeHtmlString(json['title'].toString()),
    );
  }
}

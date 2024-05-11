import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../song/song.dart';

part 'api.freezed.dart';
part 'api.g.dart';

final BankApi testApi =
    BankApi(Uri.parse('https://kiskutyafule.csecsy.hu/api/'));
final BankApi prodApi =
    BankApi(Uri.parse('https://kiskutyafule.csecsy.hu/api/'));



class BankApi {
  final Uri baseUrl;
  final Dio dio = Dio();

  BankApi(this.baseUrl);

  Future<List<ProtoSong>> getProtoSongs() async {
    final resp = await dio.get('$baseUrl/songs');
    return (resp.data as List)
        .map((e) => ProtoSong.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Song> getSongDetails(String uuid) async {
    final resp = await dio.get('$baseUrl/song/$uuid');
    return Song.fromJson(resp.data[0] as Map<String, dynamic>);
  }
}

@freezed
class ProtoSong with _$ProtoSong {
  factory ProtoSong(
    final String uuid,
    final String title,
  ) = _ProtoSong;

  factory ProtoSong.fromJson(Map<String, dynamic> json) =>
      _$ProtoSongFromJson(json);
}

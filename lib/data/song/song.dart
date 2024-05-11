import 'package:freezed_annotation/freezed_annotation.dart';
part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song with _$Song {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Song({
    required String uuid,
    required String title,
    required String titleOriginal,
    required String year,
    required String composer,
    required String lyrics,
    required String translator,
    required String pitch,
    required String ambitus,
    required String bibleRef,
    required String firstLine,
    required String language,
    required String opensong,
    required String pdf,
    required String refSongbook,
    required String genre,
    required String svg,
    required String poet,
    required String sofar,
    required String contentTags,
    required String tempo,
    required String holiday,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}


/*
{
"uuid": "3bc19485-eb2d-400f-8c2d-c542e003c7e0",
"title": "Teszt dal egy",
"title_original": "First test song",
"year": "2024",
"composer": "Dalszerző Benedek",
"lyrics": "1. Első teszt dal versszaka\r\n\r\nRefr. Első teszt dal refrénje",
"translator": "Fordító Benedek",
"pitch": "C-dúr",
"ambitus": "másfél oktáv",
"bible_ref": "1Móz 1:1",
"first_line": "Első teszt dal versszaka",
"language": "magyar",
"opensong": "[V1]\r\nElső teszt dal versszaka\r\n[C]\r\nElső teszt dal refrénje",
"pdf": "/system/files/2024-05/zh-kerdesek-kidolgozas.pdf",
"ref_songbook": "215",
"genre": "folk - ír,meditatív",
"svg": "/system/files/2024-05/filc2logo-applogo.svg",
"poet": "Szövegíró Benedek",
"sofar": "2011 - Pápa",
"content_tags": "áldás,hálaadás,megtérés",
"tempo": "közepes",
"holiday": "Pünkösd,Reformáció"
}
*/
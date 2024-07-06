import 'package:freezed_annotation/freezed_annotation.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song with _$Song {
  const Song._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Song({
    required final String uuid,
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

  Uri get pdfUri => Uri.parse(pdf);
  Uri get svgUri => Uri.parse(svg);
}

part of '../slide.dart';

class SongSlide implements Slide {
  static String slideType = 'song';
  Song song;
  SongViewType viewType;
  SongTranspose? transpose;
  Cue parentCue;
  // future: List<Verse> verses override

  bool contentDifferentFlag = false;

  //? Overrides

  @override
  String? comment;
  // TODO implement saving wheter sheet music or lyrics were opened

  @override
  String getPreview() {
    return 'Dalszöveg';
    // TODO
    /*return song.lyrics.substring(
      0,
      song.lyrics.indexOf('\n'), // todo proper bounds checking
    );*/
  }

  static Future<SongSlide> reviveFromJson(Map json, Cue parent) async {
    var songResult = await getSongForSlideJson(json['song']);

    return SongSlide(
      songResult.song,
      parent,
      viewType: SongViewType.fromString(json['viewType']),
      transpose: SongTranspose.fromJson(json['transpose']),
      comment: json['comment'],
    )..contentDifferentFlag = songResult.contentDifferentFlag;
  }

  @override
  Map toJson() {
    return {
      'slideType': slideType,
      'song': songOfSlideToJson(song),
      'viewType': viewType.name,
      'transpose': transpose?.toJson(),
      'comment': comment,
    };
  }

  SongSlide(
    this.song,
    this.parentCue, {
    required this.viewType,
    this.transpose,
    this.comment,
  });
}

Future<({Song song, bool contentDifferentFlag})> getSongForSlideJson(
  Map json,
) async {
  Song song = await dbSongFromUuid(json['uuid']);
  // far future todo: handle edge cases; reading from list file, from network, from bank, from local etc
  return (
    song: song,
    contentDifferentFlag: song.contentHash == json['contentHash'],
  );
}

Map songOfSlideToJson(Song song) {
  return {'uuid': song.uuid, 'contentHash': song.contentHash};
}

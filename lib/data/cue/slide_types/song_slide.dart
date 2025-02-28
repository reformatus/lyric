part of '../slide.dart';

// ScriptureSlide impl ..laksdm
// TextSlide impl. asdd

class SongSlide implements Slide {
  static String slideType = 'song';
  Song song;
  // future: List<Verse> verses override

  bool contentDifferentFlag = false;

  //? Overrides

  @override
  String? comment;
  // TODO implement saving wheter sheet music or lyrics were opened

  @override
  String getPreview() {
    return song.lyrics.substring(
      0,
      song.lyrics.indexOf('\n'), // todo proper bounds checking
    );
  }

  static Future<SongSlide> reviveFromJson(Map json) async {
    var songResult = await getSongForSlideJson(json['song']);

    return SongSlide(songResult.song, json['comment'])
      ..contentDifferentFlag = songResult.contentDifferentFlag;
  }

  @override
  Map toJson() {
    return {
      'slideType': slideType,
      'song': songOfSlideToJson(song),
      'comment': comment,
    };
  }

  SongSlide(this.song, [this.comment]);
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

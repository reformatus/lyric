part of '../slide.dart';

class SongSlide extends Slide {
  static String slideType = 'song';
  Song song;
  SongViewType viewType;
  SongTranspose? transpose;
  Cue parentCue;
  // future: List<Verse> verses override

  bool contentDifferentFlag = false;

  //? Overrides

  @override
  String getPreview() {
    return 'Dalszöveg';
    // TODO
    /*return song.lyrics.substring(
      0,
      song.lyrics.indexOf('\n'), // TODO proper bounds checking
    );*/
  }

  static Future<SongSlide> reviveFromJson(
    Map json,
    Cue parent, [
    Ref? ref,
  ]) async {
    var songResult = await getSongForSlideJson(json['song']);

    SongViewType viewType = SongViewType.fromString(json['viewType']);
    SongTranspose transpose = SongTranspose.fromJson(json['transpose']);

    SongSlide songSlide = SongSlide(
      json['uuid'],
      songResult.song,
      parent,
      json['comment'],
      viewType: viewType,
      transpose: transpose,
    )..contentDifferentFlag = songResult.contentDifferentFlag;

    // Initialize states for UI
    if (ref != null) {
      ref
          .read(viewTypeForProvider(songResult.song, songSlide).notifier)
          .set(viewType);
      ref
          .read(transposeStateForProvider(songResult.song, songSlide).notifier)
          .set(transpose);
    }

    return songSlide;
  }

  @override
  Map toJson() {
    return {
      'uuid': uuid,
      'slideType': slideType,
      'song': songOfSlideToJson(song),
      'viewType': viewType.name,
      'transpose': transpose?.toJson(),
      'comment': comment,
    };
  }

  SongSlide(
    super.uuid,
    this.song,
    this.parentCue,
    super.comment, {
    required this.viewType,
    this.transpose,
  });
}

Future<({Song song, bool contentDifferentFlag})> getSongForSlideJson(
  Map json,
) async {
  Song song = (await dbSongFromUuid(json['uuid']))!;
  // far future todo: handle edge cases; reading from list file, from network, from bank, from local etc
  // TODO fix
  return (
    song: song,
    contentDifferentFlag: false, //song.contentHash == json['contentHash'],
  );
}

Map songOfSlideToJson(Song song) {
  return {'uuid': song.uuid, 'contentHash': song.contentHash};
}

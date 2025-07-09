part of '../slide.dart';

class SongSlide extends Slide {
  static String slideType = 'song';
  Song song;
  SongViewType viewType;
  SongTranspose? transpose;
  Cue parentCue;
  // future: List<Verse> verses override

  bool contentDifferentFlag = false;

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
    SongTranspose? transpose = json.containsKey('transpose')
        ? SongTranspose.fromJson(json['transpose'])
        : null;

    SongSlide songSlide = SongSlide(
      json['uuid'],
      songResult.song,
      parent,
      json.containsKey('comment') ? json['comment'] : null,
      viewType: viewType,
      transpose: transpose,
    )..contentDifferentFlag = songResult.contentDifferentFlag;

    // Initialize states for UI
    if (ref != null) {
      ref
          .read(viewTypeForProvider(songResult.song, songSlide).notifier)
          .setTo(viewType);
      if (transpose != null) {
        ref
            .read(
              transposeStateForProvider(songResult.song, songSlide).notifier,
            )
            .setTo(transpose);
      }
    }

    return songSlide;
  }

  @override
  Map toJson() {
    return Map.fromEntries([
      MapEntry('uuid', uuid),
      MapEntry('slideType', slideType),
      MapEntry('song', songOfSlideToJson(song)),
      MapEntry('viewType', viewType.name),
      if (transpose != null && transpose!.isNotEmpty)
        MapEntry('transpose', transpose!.toJson()),
      if (comment != null) MapEntry('comment', comment),
    ]);
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

import 'package:json_annotation/json_annotation.dart';
import 'package:lyric/services/song/from_uuid.dart';

import '../song/song.dart';

part 'slide_types/song_slide.dart';

sealed class Slide {
  String getPreview();
  // todo have interfaces for title, subtitle, etc
  String? comment;

  static Future<Slide> reviveFromJson(Map json) {
    switch (json['slideType']) {
      case 'song':
        return SongSlide.reviveFromJson(json);
      default:
        return Future.sync(() => UnknownTypeSlide(json));
    }
  }

  Map toJson();
}

class UnknownTypeSlide extends Slide {
  Map json;

  @override
  String getPreview() => 'Ismeretlen diatípus: ${json['slideType']}';

  @override
  Map toJson() => json;

  UnknownTypeSlide(this.json);
}

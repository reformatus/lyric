import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/song/transpose/state.dart';

import '../song/transpose.dart';

import '../../services/song/from_uuid.dart';
import '../../ui/song/state.dart';
import '../song/song.dart';
import 'cue.dart';

part 'slide_types/song_slide.dart';

sealed class Slide {
  String getPreview();
  // todo have interfaces for title, subtitle, etc
  String uuid;
  String? comment;

  Slide(this.uuid, this.comment);

  static Future<Slide> reviveFromJson(Map json, Cue parent, [Ref? ref]) {
    switch (json['slideType']) {
      case 'song':
        return SongSlide.reviveFromJson(json, parent, ref);
      default:
        return Future.sync(
          () => UnknownTypeSlide(json, json['uuid'], json['comment']),
        );
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

  UnknownTypeSlide(this.json, super.uuid, super.comment);
}

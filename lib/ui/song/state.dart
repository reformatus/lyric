import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/slide.dart';
import '../../data/song/extensions.dart';
import '../../data/song/song.dart';

part 'state.g.dart';

enum SongViewType {
  svg('svg'),
  pdf('pdf'),
  lyrics('lyrics');

  final String type;
  const SongViewType(this.type);
  factory SongViewType.fromString(String type) {
    return SongViewType.values.firstWhere((e) => e.type == type);
  }
}

@Riverpod(keepAlive: true)
class ViewTypeFor extends _$ViewTypeFor {
  @override
  SongViewType build(Song song, SongSlide? songSlide) {
    if (song.hasSvg) {
      return SongViewType.svg;
    } else if (song.hasPdf) {
      return SongViewType.pdf;
    } else {
      return SongViewType.lyrics;
    }
  }

  @override
  bool updateShouldNotify(SongViewType previous, SongViewType next) {
    songSlide?.viewType = state;
    return super.updateShouldNotify(previous, next);
  }

  void set(SongViewType viewType) {
    state = viewType;
    // TODO update songSlide
  }
}

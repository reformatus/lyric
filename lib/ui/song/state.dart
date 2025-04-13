import '../../data/cue/slide.dart';

import '../../data/song/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

// TODO refactor
//* maybe make list uuid part of family definition?
//* needs to be separated - maybe song page can store state locally without provider
//* song page needs to be used in lists as well for editing transpose and view - how are these separated?

@Riverpod(keepAlive: true)
class ViewTypeFor extends _$ViewTypeFor {
  @override
  SongViewType? build(String songId, SongSlide? songSlide) {
    return null;
  }

  void changeTo(SongViewType viewType) {
    state = viewType;
  }

  Future setDefaultFor(Song song) async {
    // TODO watch and read previous preference for song/in general
    await Future.delayed(Duration.zero);
    if (song.hasSvg) {
      state = SongViewType.svg;
    } else if (song.hasPdf) {
      state = SongViewType.pdf;
    } else {
      state = SongViewType.lyrics;
    }
    return;
  }
}

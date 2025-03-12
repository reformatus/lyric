import 'package:lyric/data/song/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/song/song.dart';

part 'state.g.dart';

enum SongViewType { svg, pdf, lyrics }

@Riverpod(keepAlive: true)
class ViewTypeFor extends _$ViewTypeFor {
  @override
  SongViewType? build(String uuid) {
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

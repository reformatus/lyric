import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/song/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/song/song.dart';

part 'state.g.dart';

enum SongViewType { svg, pdf, lyrics }

@Riverpod(keepAlive: true)
class ViewTypeFor extends _$ViewTypeFor {
  @override
  SongViewType build(String uuid) {
    return SongViewType.svg;
  }

  void changeTo(SongViewType viewType) {
    state = viewType;
  }
}

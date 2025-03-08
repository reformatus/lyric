import 'package:riverpod_annotation/riverpod_annotation.dart';


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

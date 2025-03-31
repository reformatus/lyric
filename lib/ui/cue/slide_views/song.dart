import 'package:flutter/material.dart';

import '../../../data/cue/slide.dart';
import '../../../main.dart';
import '../../song/lyrics/view.dart';
import '../../song/sheet/view.dart';
import '../../song/state.dart';

class SongSlideTile extends StatelessWidget {
  const SongSlideTile(
    this.slide, {
    required this.selectCallback,
    required this.removeCallback,
    required this.selected,
    super.key,
  });

  final GestureTapCallback selectCallback;
  final GestureTapCallback removeCallback;
  final bool selected;
  final SongSlide slide;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(slide.song.title),
      onTap: selectCallback,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: removeCallback,
            icon: Icon(Icons.delete_outline),
          ),
          if (globals.isMobile) Icon(Icons.drag_handle),
        ],
      ),
      selected: selected,
    );
  }
}

class SongSlideView extends StatelessWidget {
  const SongSlideView(this.songSlide, this.cueId, {super.key});

  final SongSlide songSlide;
  final String? cueId;

  @override
  Widget build(BuildContext context) {
    return switch (songSlide.viewType) {
      SongViewType.svg => SheetView.svg(songSlide.song),
      SongViewType.pdf => SheetView.pdf(songSlide.song),
      SongViewType.lyrics => LyricsView(
        songSlide.song,
        transposeOptional: songSlide.transpose,
      ),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:lyric/data/cue/slide.dart';
import 'package:lyric/ui/song/sheet/view.dart';

class SongSlideTile extends StatelessWidget {
  const SongSlideTile(this.slide, this.selectCallback, {required this.selected, super.key});

  final GestureTapCallback selectCallback;
  final bool selected;
  final SongSlide slide;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(slide.song.title),
      onTap: selectCallback,
      selected: selected,
    );
  }
}

class SongSlideView extends StatelessWidget {
  const SongSlideView(this.songSlide, {super.key});

  final SongSlide songSlide;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: SheetView(songSlide.song));
  }
}

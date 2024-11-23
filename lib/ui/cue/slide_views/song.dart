import 'package:flutter/material.dart';
import 'package:lyric/data/cue/slide.dart';
import 'package:lyric/ui/song/sheet/view.dart';

class SongSlideTile extends StatelessWidget {
  const SongSlideTile(this.slide,
      {required this.selectCallback, required this.removeCallback, required this.selected, super.key});

  final GestureTapCallback selectCallback;
  final GestureTapCallback removeCallback;
  final bool selected;
  final SongSlide slide;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(slide.song.title),
      onTap: selectCallback,
      trailing: Padding(
        padding: EdgeInsets.only(right: 10),
        child: IconButton(onPressed: removeCallback, icon: Icon(Icons.delete_outline)),
      ),
      selected: selected,
    );
  }
}

class SongSlideView extends StatelessWidget {
  const SongSlideView(this.songSlide, {super.key});

  final SongSlide songSlide;

  @override
  Widget build(BuildContext context) {
    return SheetView(songSlide.song);
  }
}

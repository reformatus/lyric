import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    required this.isCurrent,
    super.key,
  });

  final GestureTapCallback selectCallback;
  final GestureTapCallback removeCallback;
  final bool isCurrent;
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
      selected: isCurrent,
      selectedTileColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}

class SongSlideView extends ConsumerWidget {
  const SongSlideView(this.songSlide, this.cueId, {super.key});

  final SongSlide songSlide;
  final String? cueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SongViewType viewType = ref.watch(
      viewTypeForProvider(songSlide.song, songSlide),
    );

    switch (viewType) {
      case SongViewType.svg:
        return SheetView.svg(songSlide.song);
      case SongViewType.pdf:
        return SheetView.pdf(songSlide.song);
      case SongViewType.lyrics:
        return LyricsView(songSlide.song, songSlide: songSlide);
    }
  }
}

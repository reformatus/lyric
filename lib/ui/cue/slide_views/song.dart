import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/common/error/card.dart';

import '../../../data/cue/slide.dart';
import '../../song/lyrics/view.dart';
import '../../song/sheet/view.dart';
import '../../song/state.dart';

class SongSlideTile extends StatelessWidget {
  const SongSlideTile(
    this.slide,
    this.index, {
    required this.selectCallback,
    required this.removeCallback,
    required this.isCurrent,
    super.key,
  });

  final GestureTapCallback selectCallback;
  final GestureTapCallback removeCallback;
  final bool isCurrent;
  final SongSlide slide;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ReorderableDelayedDragStartListener(
      index: index,
      child: ListTile(
        title: Text(slide.song.title),
        onTap: selectCallback,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: removeCallback,
              icon: Icon(Icons.delete_outline),
            ),
            ReorderableDragStartListener(
              index: index,
              child: Icon(Icons.drag_handle),
            ),
          ],
        ),
        selected: isCurrent,
        selectedTileColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

class SongSlideView extends ConsumerWidget {
  const SongSlideView(this.songSlide, this.cueId, {super.key});

  final SongSlide songSlide;
  final String? cueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(viewTypeForProvider(songSlide.song, songSlide));

    return viewType.when(
      data: (viewType) => switch (viewType) {
        SongViewType.svg => SheetView.svg(songSlide.song),
        SongViewType.pdf => SheetView.pdf(songSlide.song),
        SongViewType.lyrics ||
        SongViewType.chords => LyricsView(songSlide.song, songSlide: songSlide),
      },
      error: (e, s) => Center(
        child: LErrorCard(
          type: LErrorType.error,
          title: 'Hiba a dalnézet kiválasztása közben!',
          icon: Icons.error,
          message: e.toString(),
          stack: s.toString(),
        ),
      ),
      loading: SizedBox.shrink,
    );
  }
}

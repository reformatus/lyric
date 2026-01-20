import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/song/transpose.dart';
import '../state.dart';
import '../../../data/cue/slide.dart';
import '../../../data/cue/cue.dart';
import '../../cue/state.dart';

import '../../../data/song/song.dart';
import '../../../services/key/get_transposed.dart';
import 'state.dart';

class TransposeResetButton extends ConsumerWidget {
  const TransposeResetButton(
    this.song, {
    this.songSlide,
    required this.isCompact,
    super.key,
  });

  final bool isCompact;
  final Song song;
  final SongSlide? songSlide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transpose = ref.watch(transposeStateForProvider(song, songSlide));
    if (transpose.semitones != 0 || transpose.capo != 0) {
      return IconButton(
        tooltip: 'Transzponálás visszaállítása',
        onPressed: () => ref
            .read(transposeStateForProvider(song, songSlide).notifier)
            .reset(),
        icon: Icon(Icons.replay),
        iconSize: isCompact ? 18 : null,
        visualDensity: VisualDensity.compact,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class TransposeControls extends ConsumerWidget {
  const TransposeControls(this.song, {this.songSlide, this.cue, super.key});

  final Song song;
  final SongSlide? songSlide;
  final Cue? cue;

  // Helper method to update transpose in cue context
  void _updateTranspose(WidgetRef ref, void Function() transposeAction) {
    if (cue != null && songSlide != null) {
      // In cue context: create updated slide with new transpose
      transposeAction(); // Execute the transpose action
      final newTranspose = ref.read(transposeStateForProvider(song, songSlide));

      final updatedSlide = SongSlide(
        songSlide!.uuid,
        songSlide!.song,
        songSlide!.comment,
        viewType: songSlide!.viewType,
        transpose: newTranspose,
      );

      ref
          .read(currentSlideListOfProvider(cue!).notifier)
          .updateSlide(updatedSlide);
    } else {
      // In song context: call action directly
      transposeAction();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transpose = ref.watch(transposeStateForProvider(song, songSlide));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        sectionTitle(context, 'TRANSZPONÁLÁS'),
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: () {
                _updateTranspose(ref, () {
                  ref
                      .read(transposeStateForProvider(song, songSlide).notifier)
                      .down();
                });
              },
              icon: Icon(Icons.expand_more),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    transpose.semitones.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () {
                _updateTranspose(ref, () {
                  ref
                      .read(transposeStateForProvider(song, songSlide).notifier)
                      .up();
                });
              },
              icon: Icon(Icons.expand_less),
            ),
          ],
        ),
        sectionTitle(context, 'CAPO'),
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: () {
                _updateTranspose(ref, () {
                  ref
                      .read(transposeStateForProvider(song, songSlide).notifier)
                      .removeCapo();
                });
              },
              icon: Icon(Icons.remove),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    transpose.capo.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () {
                _updateTranspose(ref, () {
                  ref
                      .read(transposeStateForProvider(song, songSlide).notifier)
                      .addCapo();
                });
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  Widget sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(top: 7, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
        ),
      ),
    );
  }
}

class TransposeCard extends ConsumerWidget {
  const TransposeCard({
    super.key,
    required this.song,
    this.songSlide,
    this.cue,
  });

  final Song song;
  final SongSlide? songSlide;
  final Cue? cue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SongTranspose transpose = ref.watch(
      transposeStateForProvider(song, songSlide),
    );
    final viewTypeAsync = ref.watch(viewTypeForProvider(song, songSlide));

    if (viewTypeAsync.value != SongViewType.chords) {
      return SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 250),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text(
                      song.keyField != null
                          ? getTransposedKey(
                              song.keyField!,
                              transpose.semitones,
                            ).toString()
                          : 'Hangnem',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TransposeResetButton(
                      song,
                      songSlide: songSlide,
                      isCompact: false,
                    ),
                  ],
                ),
              ),
              TransposeControls(song, songSlide: songSlide, cue: cue),
            ],
          ),
        ),
      ),
    );
  }
}

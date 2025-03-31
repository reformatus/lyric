import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/cue/slide.dart';

import '../../../data/song/song.dart';
import 'state.dart';

class TransposeResetButton extends ConsumerWidget {
  const TransposeResetButton(
    this.song, {
    this.songSlide,
    required this.isHorizontal,
    super.key,
  });

  final bool isHorizontal;
  final Song song;
  final SongSlide? songSlide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transpose = ref.watch(
      TransposeStateForProvider(song.uuid, songSlide),
    );
    if (transpose.semitones != 0 || transpose.capo != 0) {
      return IconButton(
        tooltip: 'Transzponálás visszaállítása',
        onPressed:
            () =>
                ref
                    .read(
                      TransposeStateForProvider(song.uuid, songSlide).notifier,
                    )
                    .reset(),
        icon: Icon(Icons.replay),
        iconSize: isHorizontal ? 18 : null,
        visualDensity: VisualDensity.compact,
      );
    } else {
      return Container();
    }
  }
}

class TransposeControls extends ConsumerWidget {
  const TransposeControls(this.song, {this.songSlide, super.key});

  final Song song;
  final SongSlide? songSlide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transpose = ref.watch(
      TransposeStateForProvider(song.uuid, songSlide),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        sectionTitle(context, 'TRANSZPONÁLÁS'),
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: () {
                ref
                    .read(
                      TransposeStateForProvider(song.uuid, songSlide).notifier,
                    )
                    .down();
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
                ref
                    .read(
                      TransposeStateForProvider(song.uuid, songSlide).notifier,
                    )
                    .up();
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
                ref
                    .read(
                      TransposeStateForProvider(song.uuid, songSlide).notifier,
                    )
                    .removeCapo();
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
                ref
                    .read(
                      TransposeStateForProvider(song.uuid, songSlide).notifier,
                    )
                    .addCapo();
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

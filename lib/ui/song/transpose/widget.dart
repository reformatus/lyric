import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/song/transpose/state.dart';

import '../../../data/song/song.dart';

class TransposeResetButton extends ConsumerWidget {
  const TransposeResetButton(
    this.song, {
    required this.cueId,
    required this.isHorizontal,
    super.key,
  });

  final bool isHorizontal;
  final Song song;
  final String? cueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transpose = ref.watch(TransposeStateForProvider(song.uuid, cueId));
    if (transpose.semitones != 0 || transpose.capo != 0) {
      return IconButton(
        tooltip: 'Transzponálás visszaállítása',
        onPressed:
            () =>
                ref
                    .read(TransposeStateForProvider(song.uuid, cueId).notifier)
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
  const TransposeControls(this.song, {required this.cueId, super.key});

  final Song song;
  final String? cueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transpose = ref.watch(TransposeStateForProvider(song.uuid, cueId));

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
                    .read(TransposeStateForProvider(song.uuid, cueId).notifier)
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
                    .read(TransposeStateForProvider(song.uuid, cueId).notifier)
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
                    .read(TransposeStateForProvider(song.uuid, cueId).notifier)
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
                    .read(TransposeStateForProvider(song.uuid, cueId).notifier)
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

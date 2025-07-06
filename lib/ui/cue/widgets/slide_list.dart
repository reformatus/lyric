import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/centered_hint.dart';
import '../../common/confirm_dialog.dart';
import '../slide_views/unknown.dart';

import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';
import '../slide_views/song.dart';
import '../state.dart';

/// A drawer or side panel that displays a list of slides for a cue
/// Uses the current slide from state management instead of an index
class SlideList extends ConsumerWidget {
  const SlideList({required this.cue, super.key});

  final Cue cue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Slide? currentSlide = ref.watch(currentSlideOfProvider(cue));
    List<Slide> slides = ref.watch(currentSlideListOfProvider(cue));

    if (slides.isEmpty) return CenteredHint('Üres lista');

    return ReorderableListView.builder(
      itemCount: slides.length,
      onReorder: (int from, int to) {
        ref
            .read(currentSlideListOfProvider(cue).notifier)
            .reorderSlides(from, to);
      },
      itemBuilder: (context, index) {
        final slide = slides[index];

        return switch (slide) {
          SongSlide songSlide => SongSlideTile(
            songSlide,
            key: ValueKey(songSlide.hashCode),
            selectCallback: () => ref
                .read(currentSlideOfProvider(cue).notifier)
                .setCurrent(slide),
            removeCallback: () => showConfirmDialog(
              context,
              title: '${songSlide.song.title} - biztos eltávolítod a listából?',
              actionIcon: Icons.delete_outline,
              actionLabel: 'Eltávolítás',
              actionOnPressed: () async {
                await ref
                    .read(currentSlideListOfProvider(cue).notifier)
                    .removeSlide(slide);
              },
            ),
            isCurrent: currentSlide == slide,
          ),
          UnknownTypeSlide unknownSlide => UnknownTypeSlideTile(
            unknownSlide,
            key: ValueKey(unknownSlide.hashCode),
            selectCallback: () => ref
                .read(currentSlideOfProvider(cue).notifier)
                .setCurrent(slide),
            removeCallback: () => ref
                .read(currentSlideListOfProvider(cue).notifier)
                .removeSlide(slide),
            isCurrent: currentSlide == slide,
          ),
        };
      },
    );
  }
}

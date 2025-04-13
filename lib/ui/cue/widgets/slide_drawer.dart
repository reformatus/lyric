import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/services/cue/write_cue.dart';
import 'package:lyric/ui/cue/slide_views/unknown.dart';

import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';
import '../../../services/cue/slide/revived_slides.dart';
import '../slide_views/song.dart';
import '../state.dart';

/// A drawer or side panel that displays a list of slides for a cue
/// Uses the current slide from state management instead of an index
class SlideDrawer extends ConsumerWidget {
  const SlideDrawer({required this.cue, super.key});

  final Cue cue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Slide? currentSlide = ref.watch(currentSlideProvider);
    List<Slide> slides =
        ref.watch(revivedSlidesForCueProvider(cue)).valueOrNull ?? [];

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ReorderableListView.builder(
              itemCount: slides.length,
              onReorder: (int from, int to) => reorderCueSlides(cue, from, to),
              itemBuilder: (context, index) {
                final slide = slides[index];

                return switch (slide) {
                  SongSlide songSlide => SongSlideTile(
                    songSlide,
                    key: ValueKey(songSlide.hashCode),
                    selectCallback:
                        () => ref
                            .read(currentSlideProvider.notifier)
                            .setCurrent(slide),
                    removeCallback:
                        () => ref.read(removeSlideFromCueProvider(slide, cue)),
                    isCurrent: currentSlide == slide,
                  ),
                  UnknownTypeSlide unknownSlide => UnknownTypeSlideTile(
                    unknownSlide,
                    key: ValueKey(unknownSlide.hashCode),
                    selectCallback:
                        () => ref
                            .read(currentSlideProvider.notifier)
                            .setCurrent(unknownSlide),
                    removeCallback:
                        () => ref.read(removeSlideFromCueProvider(slide, cue)),
                    isCurrent: currentSlide == slide,
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

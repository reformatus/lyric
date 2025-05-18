import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/common/centered_hint.dart';

import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';
import '../slide_views/song.dart';
import '../slide_views/unknown.dart';
import '../state.dart';

// TODO make into tabview
class SlideView extends ConsumerWidget {
  const SlideView(this.cue, {super.key});

  final Cue cue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Slide? slide = ref.watch(currentSlideOfProvider(cue));
    ref.watch(currentSlideListOfProvider(cue));

    switch (slide) {
      case SongSlide songSlide:
        return SongSlideView(songSlide, cue.uuid);

      case UnknownTypeSlide unknownSlide:
        return UnknownTypeSlideView(unknownSlide);

      default:
        return CenteredHint('Nincs kiválasztott dia', Icons.question_mark);
    }
  }
}

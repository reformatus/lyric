import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/common/centered_hint.dart';

import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';
import '../slide_views/song.dart';
import '../slide_views/unknown.dart';
import '../state.dart';

class SlideView extends ConsumerStatefulWidget {
  const SlideView(this.cue, {super.key});

  final Cue cue;

  @override
  ConsumerState<SlideView> createState() => _SlideViewState();
}

class _SlideViewState extends ConsumerState<SlideView>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    initializeTabController(
      ref.read(currentSlideOfProvider(widget.cue)),
      ref.read(currentSlideListOfProvider(widget.cue)),
    );

    ref.listenManual(
      currentSlideOfProvider(widget.cue),
      (_, newSlide) => tabController!.animateTo(
        ref.read(currentSlideListOfProvider(widget.cue)).indexOf(newSlide!),
      ),
    );
    ref.listenManual(
      currentSlideListOfProvider(widget.cue),
      (_, slides) => initializeTabController(
        ref.read(currentSlideOfProvider(widget.cue)),
        slides,
      ),
    );
  }

  void initializeTabController(Slide? slide, List<Slide> slides) {
    setState(() {
      if (tabController != null) {
        tabController!.dispose();
      }
      tabController = TabController(
        length: slides.length,
        initialIndex: slide != null
            ? slides.indexOf(slide).clamp(0, slides.length)
            : 0,
        vsync: this,
      );
      tabController!.addListener(
        () => ref
            .read(currentSlideOfProvider(widget.cue).notifier)
            .setCurrent(
              ref.read(
                currentSlideListOfProvider(widget.cue),
              )[tabController!.index],
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Slide> slides = ref.watch(currentSlideListOfProvider(widget.cue));

    return Theme(
      data: Theme.of(context),
      child: Hero(
        tag: 'SlideView',
        child: slides.isEmpty
            ? CenteredHint(
                'Keress és adj hozzá dalokat a listához a Daltár oldalon',
                iconData: Icons.library_music,
              )
            : TabBarView(
                controller: tabController,
                children: slides.map((s) => renderSlide(s)).toList(),
              ),
      ),
    );
  }

  Widget renderSlide(Slide slide) {
    switch (slide) {
      case SongSlide songSlide:
        return SongSlideView(songSlide, widget.cue.uuid);

      case UnknownTypeSlide unknownSlide:
        return UnknownTypeSlideView(unknownSlide);
    }
  }
}

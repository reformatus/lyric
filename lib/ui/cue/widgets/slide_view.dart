import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/centered_hint.dart';

import '../../../data/cue/slide.dart';
import '../slide_views/song.dart';
import '../slide_views/unknown.dart';
import '../session/session_provider.dart';

class SlideView extends ConsumerStatefulWidget {
  const SlideView({super.key});

  @override
  ConsumerState<SlideView> createState() => _SlideViewState();
}

class _SlideViewState extends ConsumerState<SlideView>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    final session = ref.read(activeCueSessionProvider).value;
    if (session != null) {
      initializeTabController(session.currentSlide, session.slides);
    }

    ref.listenManual(
      currentSlideProvider,
      (_, newSlide) {
        final slides = ref.read(activeCueSessionProvider).value?.slides ?? [];
        if (newSlide == null || slides.isEmpty || tabController == null) return;
        tabController!.animateTo(slides.indexOf(newSlide));
      },
    );
    ref.listenManual(
      activeCueSessionProvider,
      (_, sessionAsync) {
        final sessionValue = sessionAsync.value;
        if (sessionValue == null) return;
        initializeTabController(
          sessionValue.currentSlide,
          sessionValue.slides,
        );
      },
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
        () {
          final session = ref.read(activeCueSessionProvider).value;
          if (session == null || session.slides.isEmpty) return;
          final slide = session.slides[tabController!.index];
          ref.read(activeCueSessionProvider.notifier).goToSlide(slide.uuid);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeCueSessionProvider).value;
    final slides = session?.slides ?? [];
    final cueUuid = session?.cue.uuid ?? '';

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
                children: slides.map((s) => renderSlide(s, cueUuid)).toList(),
              ),
      ),
    );
  }

  Widget renderSlide(Slide slide, String cueUuid) {
    switch (slide) {
      case SongSlide songSlide:
        return SongSlideView(songSlide, cueUuid);

      case UnknownTypeSlide unknownSlide:
        return UnknownTypeSlideView(unknownSlide);
    }
  }
}

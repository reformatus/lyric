import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/slide.dart';
import '../../data/cue/cue.dart';
import '../../services/cue/write_cue.dart';

part "state.g.dart";

@Riverpod(keepAlive: true)
class CurrentSlideOf extends _$CurrentSlideOf {
  @override
  Slide? build(Cue cue) {
    return null;
  }

  void setCurrent(Slide? slide) {
    state = slide;
  }

  Future setCurrentWithUuid(String uuid) async {
    List<Slide> slides = await ref.read(currentSlideListOfProvider(cue));

    try {
      state = slides.firstWhere((slide) => slide.uuid == uuid);
    } catch (_) {
      state = null;
    }
  }

  Future setFirst() async {
    List<Slide> slides = await ref.read(currentSlideListOfProvider(cue));

    if (slides.isNotEmpty) {
      state = slides.first;
    } else {
      state = null;
    }
  }

  /// Navigate to the slide with offset if available (e.g. 1 for next slide, -1 for previous slide)
  /// Returns true if navigation was successful, false if offset invalid
  bool changeSlide(int offset) {
    if (state == null) return false;

    List<Slide> slides = ref.read(currentSlideListOfProvider(cue));
    final currentIndex = slides.indexWhere(
      (slide) => slide.uuid == state!.uuid,
    );
    if (currentIndex == -1 ||
        currentIndex + offset < 0 ||
        currentIndex + offset >= slides.length) {
      return false;
    }

    state = slides[currentIndex + offset];
    return true;
  }
}

@Riverpod(keepAlive: true)
Stream<({int index, int total})?> watchSlideIndexOfCue(
  Ref ref,
  Cue cue,
) async* {
  List<Slide> slides = ref.watch(currentSlideListOfProvider(cue));

  final slide = ref.watch(currentSlideOfProvider(cue));

  final currentIndex = slides.indexWhere((s) => s.uuid == slide?.uuid);
  if (currentIndex == -1) yield null;

  yield (index: currentIndex, total: slides.length);
}

@Riverpod(keepAlive: true)
class CurrentSlideListOf extends _$CurrentSlideListOf {
  @override
  List<Slide> build(Cue cue) {
    return [];
  }

  Future loadSlides() async {
    state = await cue.getRevivedSlides();
  }

  void reorderSlides(int from, int to) {
    List<Slide> newState = [...state];
    final item = newState.removeAt(from);
    newState.insert(to > from ? to - 1 : to, item);

    state = newState;

    updateCueSlides(cue, state);
  }

  void removeSlide(Slide slide) {
    if (slide == ref.read(currentSlideOfProvider(cue))) {
      if (ref.read(currentSlideOfProvider(cue).notifier).changeSlide(1)) {
      } else if (ref
          .read(currentSlideOfProvider(cue).notifier)
          .changeSlide(-1)) {
      } else {
        ref.read(currentSlideOfProvider(cue).notifier).setCurrent(null);
      }
    }

    final newState = [...state];
    newState.removeWhere((s) => s == slide);
    state = newState;

    updateCueSlides(cue, state);
  }
}

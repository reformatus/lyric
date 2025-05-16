import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/cue/slide/revived_slides.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/slide.dart';
import '../../data/cue/cue.dart';

part "state.g.dart";

@Riverpod(keepAlive: true)
class CurrentSlide extends _$CurrentSlide {
  @override
  Slide? build() {
    return null;
  }

  void setCurrent(Slide slide) {
    state = slide;
  }

  Future setCurrentWithUuid(String uuid) async {
    Cue? cue = ref.read(currentCueProvider);
    List<Slide> slides = await ref.read(
      revivedSlidesForCueProvider(cue).future,
    );

    state = (slides as List<Slide?>).firstWhere(
      (slide) => slide?.uuid == uuid,
      orElse: () => null,
    );
  }

  Future setFirst() async {
    Cue? cue = ref.read(currentCueProvider);

    if (cue != null) {
      List<Slide> slides = await ref.read(
        revivedSlidesForCueProvider(cue).future,
      );

      if (slides.isNotEmpty) {
        state = slides.first;
      } else {
        state = null;
      }
    }
  }

  /// Navigate to the slide with offset if available (e.g. 1 for next slide, -1 for previous slide)
  /// Returns true if navigation was successful, false if offset invalid
  Future<bool> changeSlide(int offset) async {
    if (state == null) return false;

    Cue? cue = ref.read(currentCueProvider);
    if (cue == null) return false;

    List<Slide> slides =
        await ref.read(revivedSlidesForCueProvider(cue).future) ?? [];

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
Stream<({int index, int total})?> watchSlideIndex(Ref ref) async* {
  Cue? cue = ref.read(currentCueProvider);
  if (cue == null) yield null;

  List<Slide> slides = await ref.read(revivedSlidesForCueProvider(cue).future);

  final slide = ref.watch(currentSlideProvider);

  final currentIndex = slides.indexWhere((s) => s.uuid == slide?.uuid);
  if (currentIndex == -1) yield null;

  yield (index: currentIndex, total: slides.length);
}

@Riverpod(keepAlive: true)
class CurrentCue extends _$CurrentCue {
  @override
  Cue? build() {
    return null;
  }

  void setCurrent(Cue cue) {
    state = cue;
  }
}

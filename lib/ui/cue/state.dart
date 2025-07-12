import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../song/state.dart';
import '../song/transpose/state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/slide.dart';
import '../../data/cue/cue.dart';
import '../../services/cue/from_uuid.dart';
import '../../services/cue/write_cue.dart';

part "state.g.dart";

enum CuePageType {
  edit,
  musician,
  //stage, present, control
}

@Riverpod(keepAlive: true)
class CurrentCue extends _$CurrentCue {
  @override
  Cue? build() {
    return null;
  }

  bool isDifferent(String uuid) {
    return (state == null || state!.uuid != uuid);
  }

  ProviderSubscription? _cueChangeListener;

  Future<Cue> load(String uuid, {String? initialSlideUuid}) async {
    _cueChangeListener?.close();
    _cueChangeListener = ref.listen(
      watchCueWithUuidProvider(uuid),
      (_, _) => load(uuid),
    );

    //if (!isDifferent(uuid)) return state!;

    final cue = await ref.watch(watchCueWithUuidProvider(uuid).future);

    // Load and revive slides, then initialize the slide list provider
    //if (ref.read(currentSlideListOfProvider(cue)) == null) {
    final revivedSlides = await cue.getRevivedSlides();

    // Initialize the CurrentSlideListOf provider with the revived slides
    ref
        .read(currentSlideListOfProvider(cue).notifier)
        ._initializeSlides(revivedSlides);
    //}

    // Set current slide based on initialSlideUuid or default to first slide
    if (initialSlideUuid != null) {
      await ref
          .read(currentSlideOfProvider(cue).notifier)
          .setCurrentWithUuid(initialSlideUuid);
    } else if (ref.read(currentSlideOfProvider(cue)) == null) {
      await ref.read(currentSlideOfProvider(cue).notifier).setFirst();
    }

    state = cue;
    return cue;
  }
}

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
    List<Slide> slides = await ref.read(currentSlideListOfProvider(cue)) ?? [];

    try {
      state = slides.firstWhere((slide) => slide.uuid == uuid);
    } catch (_) {
      state = null;
    }
  }

  Future setFirst() async {
    List<Slide> slides = await ref.read(currentSlideListOfProvider(cue)) ?? [];

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

    List<Slide> slides = ref.read(currentSlideListOfProvider(cue)) ?? [];
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
  List<Slide> slides = ref.watch(currentSlideListOfProvider(cue)) ?? [];

  final slide = ref.watch(currentSlideOfProvider(cue));

  final currentIndex = slides.indexWhere((s) => s.uuid == slide?.uuid);
  if (currentIndex == -1) yield null;

  yield (index: currentIndex, total: slides.length);
}

bool hasPreviousSlide(({int index, int total})? slideIndex) =>
    slideIndex != null && slideIndex.index > 0;
bool hasNextSlide(({int index, int total})? slideIndex) =>
    slideIndex != null && slideIndex.index < slideIndex.total - 1;

// TODO continue: refactor with AsyncValue and async builder
@Riverpod(keepAlive: true)
class CurrentSlideListOf extends _$CurrentSlideListOf {
  @override
  List<Slide>? build(Cue cue) {
    return null;
  }

  // Private method to initialize slides from parent provider
  void _initializeSlides(List<Slide> slides) {
    state = slides;

    // Initialize providers for all slides
    for (final slide in slides) {
      _syncSlideWithProviders(slide);
    }
  }

  /// Synchronize a slide's state with its corresponding providers
  void _syncSlideWithProviders(Slide slide) {
    switch (slide) {
      case SongSlide songSlide:
        // Update view type provider to match the slide
        ref
            .watch(viewTypeForProvider(songSlide.song, songSlide).notifier)
            .setTo(songSlide.viewType);

        // Update transpose provider if transpose is set
        if (songSlide.transpose != null) {
          ref
              .watch(
                transposeStateForProvider(songSlide.song, songSlide).notifier,
              )
              .setTo(songSlide.transpose!);
        }
      default:
        // For unknown slide types, no provider synchronization needed
        break;
    }
  }

  /// General method to update a slide and persist changes to DB
  /// Takes an updated slide instance and synchronizes it with providers and DB
  Future<void> updateSlide(Slide updatedSlide) async {
    if (state == null) return;

    final slideIndex = state!.indexWhere((s) => s.uuid == updatedSlide.uuid);
    if (slideIndex == -1) return;

    // Replace the slide in the state
    final newState = [...state!];
    newState[slideIndex] = updatedSlide;
    state = newState;

    // Synchronize slide with providers
    // far future todo: This should'nt be necessary, if the call from _initializeSlides worked every time.
    _syncSlideWithProviders(updatedSlide);

    // Persist to database
    await updateCueSlides(cue, state!);
  }

  Future addSlide(Slide slide, {int atIndex = 0}) async {
    final newState = [...state!];

    newState.insert(atIndex, slide);
    state = newState;

    await updateCueSlides(cue, state!);
    return;
  }

  void reorderSlides(int from, int to) {
    List<Slide> newState = [...state!];
    final item = newState.removeAt(from);
    newState.insert(to > from ? to - 1 : to, item);

    state = newState;

    updateCueSlides(cue, state!);
  }

  Future removeSlide(Slide slide) async {
    if (slide == ref.read(currentSlideOfProvider(cue))) {
      if (ref.read(currentSlideOfProvider(cue).notifier).changeSlide(1)) {
      } else if (ref
          .read(currentSlideOfProvider(cue).notifier)
          .changeSlide(-1)) {
      } else {
        ref.read(currentSlideOfProvider(cue).notifier).setCurrent(null);
      }
    }

    final newState = [...state!];
    newState.removeWhere((s) => s == slide);
    state = newState;

    await updateCueSlides(cue, state!);
    return;
  }
}

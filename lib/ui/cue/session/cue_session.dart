import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';

/// Immutable state representing an active cue editing/viewing session
class CueSession {
  final Cue cue;
  final List<Slide> slides;
  final String? currentSlideUuid;

  const CueSession({
    required this.cue,
    required this.slides,
    this.currentSlideUuid,
  });

  /// Get the currently selected slide, if any
  Slide? get currentSlide {
    if (currentSlideUuid == null) return null;
    try {
      return slides.firstWhere((s) => s.uuid == currentSlideUuid);
    } catch (_) {
      return null;
    }
  }

  /// Get the index of the current slide (null if none selected or not found)
  int? get currentIndex {
    if (currentSlideUuid == null) return null;
    final index = slides.indexWhere((s) => s.uuid == currentSlideUuid);
    return index == -1 ? null : index;
  }

  /// Whether there's a next slide to navigate to
  bool get hasNext => (currentIndex ?? -1) < slides.length - 1;

  /// Whether there's a previous slide to navigate to
  bool get hasPrevious => (currentIndex ?? 0) > 0;

  /// Total number of slides
  int get slideCount => slides.length;

  /// Create copy with new slides list
  CueSession withSlides(List<Slide> newSlides) => CueSession(
    cue: cue,
    slides: newSlides,
    currentSlideUuid: currentSlideUuid,
  );

  /// Create copy with different current slide
  CueSession withCurrentSlide(String? uuid) =>
      CueSession(cue: cue, slides: slides, currentSlideUuid: uuid);

  /// Create copy with one slide replaced (matched by uuid)
  CueSession withUpdatedSlide(Slide updated) {
    final newSlides = slides
        .map((s) => s.uuid == updated.uuid ? updated : s)
        .toList();
    return withSlides(newSlides);
  }

  /// Create copy with slide added at position
  CueSession withAddedSlide(Slide slide, {int? atIndex}) {
    final newSlides = [...slides];
    newSlides.insert(atIndex ?? newSlides.length, slide);
    return withSlides(newSlides);
  }

  /// Create copy with slide removed
  CueSession withRemovedSlide(String slideUuid) {
    final newSlides = slides.where((s) => s.uuid != slideUuid).toList();
    return withSlides(newSlides);
  }

  /// Create copy with slides reordered
  CueSession withReorderedSlides(int oldIndex, int newIndex) {
    final newSlides = [...slides];
    final item = newSlides.removeAt(oldIndex);
    final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    newSlides.insert(adjustedIndex, item);
    return withSlides(newSlides);
  }

  /// Create copy with updated cue metadata
  CueSession withCue(Cue newCue) => CueSession(
    cue: newCue,
    slides: slides,
    currentSlideUuid: currentSlideUuid,
  );
}

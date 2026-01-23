import 'dart:async';

import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cue/slide.dart';
import '../../../data/log/logger.dart';
import '../../../services/cue/source/cue_source.dart';
import '../../../services/cue/source/local_source.dart';
import 'cue_session.dart';

part 'session_provider.g.dart';

/// The single source of truth for the currently active cue session.
///
/// All slide mutations go through this provider, which handles:
/// - Immutable state updates for immediate UI reactivity
/// - Debounced writes to the underlying source (DB/remote)
/// - External change integration (for future remote collaboration)
@Riverpod(keepAlive: true)
class ActiveCueSession extends _$ActiveCueSession {
  CueSource? _source;
  Timer? _writeDebounce;
  StreamSubscription<CueSourceEvent>? _externalChangesSubscription;

  static const _writeDebounceDuration = Duration(milliseconds: 300);

  @override
  Future<CueSession?> build() async {
    // Cleanup on provider disposal
    ref.onDispose(_cleanup);

    // No cue loaded initially
    return null;
  }

  void _cleanup() {
    _writeDebounce?.cancel();
    _externalChangesSubscription?.cancel();
    _source?.dispose();
  }

  /// Load a cue by UUID, optionally jumping to a specific slide.
  /// This is idempotent - calling with the same UUID returns early if already loaded.
  Future<void> load(String uuid, {String? initialSlideUuid}) async {
    // Check if already loaded (avoid unnecessary reload)
    final current = state.value;
    if (current != null && current.cue.uuid == uuid) {
      // Already loaded - just update current slide if requested
      if (initialSlideUuid != null &&
          initialSlideUuid != current.currentSlideUuid) {
        state = AsyncValue.data(current.withCurrentSlide(initialSlideUuid));
      }
      return;
    }

    // Cancel any pending operations from previous session
    _cleanup();

    // Set loading state
    state = const AsyncValue.loading();

    // Create source (for now always local, future: check cue metadata for remote)
    _source = LocalCueSource(uuid);

    try {
      // Fetch cue metadata
      final cue = await _source!.fetchCue();

      // Revival happens here, inside load
      final slides = await _source!.reviveSlides(cue);

      // Determine initial slide
      final initialUuid = initialSlideUuid ?? slides.firstOrNull?.uuid;

      state = AsyncValue.data(
        CueSession(cue: cue, slides: slides, currentSlideUuid: initialUuid),
      );

      // Listen for external changes (relevant for future remote sources)
      _externalChangesSubscription = _source!.externalChanges.listen(
        _handleExternalChange,
      );

      log.info('Lista betöltve: ${cue.title} (${slides.length} dia)');
    } catch (e, s) {
      log.severe('Hiba lista betöltése közben:', e, s);
      state = AsyncValue.error(e, s);
    }
  }

  /// Unload the current cue (e.g., when closing the cue view)
  void unload() {
    _cleanup();
    state = const AsyncValue.data(null);
  }

  /// Handle external changes from the source (for remote collaboration)
  void _handleExternalChange(CueSourceEvent event) {
    final session = state.value;
    if (session == null) return;

    switch (event) {
      case SlidesChangedEvent(:final slides):
        state = AsyncValue.data(session.withSlides(slides));
      case CurrentSlideChangedEvent(:final slideUuid):
        state = AsyncValue.data(session.withCurrentSlide(slideUuid));
      case CueMetadataChangedEvent(:final cue):
        state = AsyncValue.data(session.withCue(cue));
    }
  }

  // ============================================================
  // Navigation
  // ============================================================

  /// Navigate to next/previous slide by offset (1 = next, -1 = previous)
  /// Returns true if navigation succeeded
  bool navigate(int offset) {
    final session = state.value;
    if (session == null || session.currentIndex == null) return false;

    final newIndex = session.currentIndex! + offset;
    if (newIndex < 0 || newIndex >= session.slides.length) return false;

    state = AsyncValue.data(
      session.withCurrentSlide(session.slides[newIndex].uuid),
    );
    // Navigation doesn't trigger DB write
    return true;
  }

  /// Jump to a specific slide by UUID
  void goToSlide(String slideUuid) {
    final session = state.value;
    if (session == null) return;

    // Verify slide exists
    if (!session.slides.any((s) => s.uuid == slideUuid)) return;

    state = AsyncValue.data(session.withCurrentSlide(slideUuid));
  }

  /// Go to first slide
  void goToFirst() {
    final session = state.value;
    if (session == null || session.slides.isEmpty) return;

    state = AsyncValue.data(
      session.withCurrentSlide(session.slides.first.uuid),
    );
  }

  // ============================================================
  // Slide Mutations - THE single path for all slide changes
  // ============================================================

  /// Update a slide's properties (viewType, transpose, comment, etc.)
  /// This is the main mutation method - creates immutable copy and schedules write
  void updateSlide(Slide updated) {
    final session = state.value;
    if (session == null) return;

    // Verify slide exists
    if (!session.slides.any((s) => s.uuid == updated.uuid)) {
      log.warning('Tried to update non-existent slide: ${updated.uuid}');
      return;
    }

    // Immediate UI update (immutable)
    state = AsyncValue.data(session.withUpdatedSlide(updated));

    // Debounced persistence
    _scheduleWrite();
  }

  /// Add a new slide to the cue
  void addSlide(Slide slide, {int? atIndex}) {
    final session = state.value;
    if (session == null) return;

    final newSession = session.withAddedSlide(slide, atIndex: atIndex);

    // If no slide was selected, select the new one
    final finalSession = session.currentSlideUuid == null
        ? newSession.withCurrentSlide(slide.uuid)
        : newSession;

    state = AsyncValue.data(finalSession);
    _scheduleWrite();
  }

  /// Remove a slide from the cue
  void removeSlide(String slideUuid) {
    final session = state.value;
    if (session == null) return;

    // If removing current slide, navigate to adjacent one first
    if (session.currentSlideUuid == slideUuid) {
      final currentIndex = session.currentIndex ?? 0;
      String? newCurrentUuid;

      if (session.slides.length > 1) {
        // Prefer next slide, fall back to previous
        if (currentIndex < session.slides.length - 1) {
          newCurrentUuid = session.slides[currentIndex + 1].uuid;
        } else if (currentIndex > 0) {
          newCurrentUuid = session.slides[currentIndex - 1].uuid;
        }
      }

      state = AsyncValue.data(
        session.withCurrentSlide(newCurrentUuid).withRemovedSlide(slideUuid),
      );
    } else {
      state = AsyncValue.data(session.withRemovedSlide(slideUuid));
    }

    _scheduleWrite();
  }

  /// Reorder slides (for drag-and-drop)
  void reorderSlides(int oldIndex, int newIndex) {
    final session = state.value;
    if (session == null) return;

    state = AsyncValue.data(session.withReorderedSlides(oldIndex, newIndex));
    _scheduleWrite();
  }

  // ============================================================
  // Write Scheduling
  // ============================================================

  void _scheduleWrite() {
    _writeDebounce?.cancel();
    _writeDebounce = Timer(_writeDebounceDuration, _executeWrite);
  }

  Future<void> _executeWrite() async {
    final session = state.value;
    if (session == null || _source == null) return;

    try {
      await _source!.writeSlides(session.slides);
      log.fine('Lista mentve: ${session.cue.title}');
    } catch (e, s) {
      log.severe('Hiba lista mentése közben:', e, s);
      // TODO: Show user-facing error with retry option
      // For now, state remains optimistic - user can retry by making another change
    }
  }

  /// Force immediate write (e.g., before navigation away)
  Future<void> flushWrites() async {
    _writeDebounce?.cancel();
    await _executeWrite();
  }
}

// ============================================================
// Helper Providers for UI Convenience
// ============================================================

/// Watch just the current slide (convenience for widgets that only need this)
@riverpod
Slide? currentSlide(Ref ref) {
  return ref.watch(activeCueSessionProvider).value?.currentSlide;
}

/// Watch slide index info (for navigation UI)
@riverpod
({int index, int total})? slideIndex(Ref ref) {
  final session = ref.watch(activeCueSessionProvider).value;
  if (session == null || session.currentIndex == null) return null;
  return (index: session.currentIndex!, total: session.slideCount);
}

/// Check if navigation is possible
@riverpod
bool canNavigatePrevious(Ref ref) {
  return ref.watch(activeCueSessionProvider).value?.hasPrevious ?? false;
}

@riverpod
bool canNavigateNext(Ref ref) {
  return ref.watch(activeCueSessionProvider).value?.hasNext ?? false;
}

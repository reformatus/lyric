import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cue/slide.dart';
import '../../../data/song/song.dart';
import '../../../data/song/transpose.dart';
import '../../cue/session/session_provider.dart';

part 'state.g.dart';

/// Provider for transpose state of a song.
///
/// Behavior depends on context:
/// - **In cue context** (`songSlide != null`): Derives state from ActiveCueSession.
///   Changes route through session for persistence.
/// - **Standalone** (`songSlide == null`): Holds independent local state.
@Riverpod(keepAlive: true)
class TransposeStateFor extends _$TransposeStateFor {
  @override
  SongTranspose build(Song song, SongSlide? songSlide) {
    // CASE 1: In cue context - derive from session
    if (songSlide != null) {
      final session = ref.watch(activeCueSessionProvider).value;
      if (session != null) {
        // Find the current version of this slide in the session
        final currentSlide = session.slides
            .whereType<SongSlide>()
            .where((s) => s.uuid == songSlide.uuid)
            .firstOrNull;

        if (currentSlide != null) {
          return currentSlide.transpose ?? SongTranspose();
        }
      }
      // Fallback to slide's stored value if session not ready
      return songSlide.transpose ?? SongTranspose();
    }

    // CASE 2: Standalone - start fresh
    return SongTranspose(semitones: 0, capo: 0);
  }

  /// Internal helper to update transpose via session or local state
  void _updateState(SongTranspose newTranspose) {
    if (songSlide != null) {
      // Route through session for cue context
      final notifier = ref.read(activeCueSessionProvider.notifier);
      final session = ref.read(activeCueSessionProvider).value;

      if (session != null) {
        final currentSlide = session.slides
            .whereType<SongSlide>()
            .where((s) => s.uuid == songSlide!.uuid)
            .firstOrNull;

        if (currentSlide != null) {
          notifier.updateSlide(currentSlide.copyWith(transpose: newTranspose));
          return; // Session update will trigger rebuild via ref.watch
        }
      }
    }
    // Standalone: direct state update
    state = newTranspose;
  }

  void setTo(SongTranspose transpose) {
    _updateState(transpose);
  }

  void up() {
    int newSemitones = state.semitones + 1;
    if (newSemitones > 11) newSemitones = 0;
    _updateState(SongTranspose(semitones: newSemitones, capo: state.capo));
  }

  void down() {
    int newSemitones = state.semitones - 1;
    if (newSemitones < -11) newSemitones = 0;
    _updateState(SongTranspose(semitones: newSemitones, capo: state.capo));
  }

  void addCapo() {
    int newCapo = state.capo + 1;
    if (newCapo > 11) newCapo = 0;
    _updateState(SongTranspose(semitones: state.semitones, capo: newCapo));
  }

  void removeCapo() {
    int newCapo = state.capo - 1;
    if (newCapo < 0) newCapo = 11;
    _updateState(SongTranspose(semitones: state.semitones, capo: newCapo));
  }

  void reset() {
    _updateState(SongTranspose(semitones: 0, capo: 0));
  }
}

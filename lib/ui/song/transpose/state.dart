import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cue/slide.dart';
import '../../../data/song/song.dart';
import '../../../data/song/transpose.dart';

part 'state.g.dart';

@Riverpod(keepAlive: true)
class TransposeStateFor extends _$TransposeStateFor {
  @override
  SongTranspose build(Song song, SongSlide? songSlide) {
    return SongTranspose(semitones: 0, capo: 0);
  }

  @override
  bool updateShouldNotify(SongTranspose previous, SongTranspose next) {
    songSlide?.transpose = state;
    return super.updateShouldNotify(previous, next);
  }

  void setTo(SongTranspose transpose) {
    state = transpose;
  }

  void up() {
    state.semitones += 1;
    if (state.semitones > 11) state.semitones = 0;
    ref.notifyListeners();
  }

  void down() {
    state.semitones -= 1;
    if (state.semitones < -11) state.semitones = 0;
    ref.notifyListeners();
  }

  void addCapo() {
    state.capo += 1;
    if (state.capo > 11) state.capo = 0;
    ref.notifyListeners();
  }

  void removeCapo() {
    state.capo -= 1;
    if (state.capo < 0) state.capo = 11;
    ref.notifyListeners();
  }

  void reset() {
    state = SongTranspose(semitones: 0, capo: 0);
    ref.notifyListeners();
  }
}

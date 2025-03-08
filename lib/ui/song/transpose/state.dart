import 'package:lyric/data/song/transpose.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state.g.dart';

@Riverpod(keepAlive: true)
class TransposeState extends _$TransposeState {
  @override
  SongTranspose build() {
    return SongTranspose(semitones: 0, capo: 0);
  }

  up() {
    state.semitones += 1;
    if (state.semitones > 11) state.semitones = 0;
    ref.notifyListeners();
  }

  down() {
    state.semitones -= 1;
    if (state.semitones < -11) state.semitones = 0;
    ref.notifyListeners();
  }

  addCapo() {
    state.capo += 1;
    if (state.capo > 11) state.capo = 0;
    ref.notifyListeners();
  }

  removeCapo() {
    state.capo -= 1;
    if (state.capo < 0) state.capo = 11;
    ref.notifyListeners();
  }

  reset() {
    state = SongTranspose(semitones: 0, capo: 0);
    ref.notifyListeners();
  }
}

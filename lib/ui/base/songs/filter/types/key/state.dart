import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../data/song/song.dart';

part 'state.g.dart';

typedef KeyFilters =
    ({Set<String> pitches, Set<String> modes, Set<KeyField> keys});

extension KeyFiltersExtension on KeyFilters {
  bool get isEmpty {
    return pitches.isEmpty && modes.isEmpty && keys.isEmpty;
  }

  bool get isNotEmpty {
    return !isEmpty;
  }
}

@Riverpod(keepAlive: true)
class KeyFilterState extends _$KeyFilterState {
  @override
  KeyFilters build() {
    return (pitches: {}, modes: {}, keys: {});
  }

  void reset() {
    state = build();
  }

  void setPitchTo(String pitch, bool value) {
    if (value) {
      if (state.pitches.add(pitch)) ref.notifyListeners();
    } else {
      if (state.pitches.remove(pitch)) ref.notifyListeners();
    }
  }

  void setModeTo(String mode, bool value) {
    if (value) {
      if (state.modes.add(mode)) ref.notifyListeners();
    } else {
      if (state.modes.remove(mode)) ref.notifyListeners();
    }
  }

  void setKeyTo(KeyField keyField, bool value) {
    if (value) {
      state.pitches.remove(keyField.pitch);
      state.modes.remove(keyField.mode);
      state.keys.add(keyField);
      ref.notifyListeners();
    } else {
      if (state.keys.remove(keyField)) ref.notifyListeners();
    }
  }
}

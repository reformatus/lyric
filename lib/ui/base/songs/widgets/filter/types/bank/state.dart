import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state.g.dart';

@Riverpod(keepAlive: true)
class BanksFilterState extends _$BanksFilterState {
  @override
  Set<String> build() {
    return {};
  }

  void toggle(String uuid) {
    if (!state.add(uuid)) {
      state.remove(uuid);
    }

    ref.notifyListeners();
  }

  /// Returns true if state has changed
  bool setFilter(String uuid, bool setTo) {
    bool changed = false;
    if (setTo) {
      changed = state.add(uuid);
    } else {
      changed = state.remove(uuid);
    }
    if (changed) ref.notifyListeners();
    return changed;
  }

  void reset() {
    state = {};
  }
}

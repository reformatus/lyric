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
  bool setFilter(String uuid, bool setTo, {bool clearOthers = false}) {
    bool changed = false;
    if (setTo) {
      if (clearOthers) {
        state = {uuid};
        changed = true;
      }
      changed = state.add(uuid);
    } else {
      assert(
        !clearOthers,
        "'Clear others' only makes sense if we're setting a new bank as filter!",
      );
      changed = state.remove(uuid);
    }
    if (changed) ref.notifyListeners();
    return changed;
  }

  void reset() {
    state = {};
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state.g.dart';

@Riverpod(keepAlive: true)
class MultiselectTagsFilterState extends _$MultiselectTagsFilterState {
  @override
  Map<String, List<String>> build() {
    return {};
  }

  @override
  String toString() {
    return state.values.map((e) => e.join(' ')).join(' | ');
  }

  void addFilter(String field, String value) {
    if (state.containsKey(field)) {
      state[field]!.add(value);
    } else {
      state[field] = [value];
    }
    ref.notifyListeners();
  }

  void removeFilter(String field, String value) {
    if (state.containsKey(field)) {
      state[field]!.remove(value);
      if (state[field]!.isEmpty) {
        state.remove(field);
      }
      ref.notifyListeners();
    }
  }

  void toggleFilter(String field, String value) {
    if (state.containsKey(field) && state[field]!.contains(value)) {
      removeFilter(field, value);
    } else {
      addFilter(field, value);
    }
    ref.notifyListeners();
  }

  void resetFilterField(String field) {
    state.remove(field);
    state = Map.fromEntries(state.entries.skipWhile((e) => e.key == field));
  }

  void resetAllFilters() {
    state = {};
  }
}

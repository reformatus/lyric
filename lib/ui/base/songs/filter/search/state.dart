import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../services/songs/filter.dart';

part 'state.g.dart';


@Riverpod(keepAlive: true)
class SearchFieldsState extends _$SearchFieldsState {
  @override
  List<String> build() {
    return [...fullTextSearchFields];
  }

  void addSearchField(String field) {
    if (!state.contains(field)) {
      state.add(field);
      ref.notifyListeners();
    }
  }

  void removeSearchField(String field) {
    if (state.length < 2) return; // Make sure at least one column stays selected
    state.remove(field);
    ref.notifyListeners();
  }
}

@Riverpod(keepAlive: true)
class SearchStringState extends _$SearchStringState {
  @override
  String build() {
    return "";
  }

  void set(String value) {
    state = value;
  }

  void clear() {
    state = "";
  }
}
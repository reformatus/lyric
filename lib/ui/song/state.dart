import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state.g.dart';

@Riverpod(keepAlive: true)
class ShowLyrics extends _$ShowLyrics {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}

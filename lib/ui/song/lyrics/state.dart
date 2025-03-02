import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state.g.dart';

@Riverpod(keepAlive: true)
class TransposeState extends _$TransposeState {
  @override
  int build() {
    return 0;
  }

  increment() {
    state = state + 1;
  }

  decrement() {
    state = state - 1;
  }
}

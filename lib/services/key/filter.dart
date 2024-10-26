import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
Future<List<String>> selectableKeyRootsFor(Ref ref, {String? mode}) {
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
Future<List<String>> selectableKeyModesFor(Ref ref, {String? root}) {
  throw UnimplementedError();
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cue/slide.dart';
import '../from_uuid.dart';

part 'watch_revived.g.dart';

@riverpod
Stream<List<Slide>> watchRevivedSlidesForCueWithUuid(Ref ref, String uuid) async* {
  final cue = ref.watch(watchCueWithUuidProvider(uuid));

  if (cue.hasValue) {
    yield await cue.requireValue.getRevivedSlides();
  }
}

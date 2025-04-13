import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';

part 'revived_slides.g.dart';

@Riverpod(keepAlive: true)
Future<List<Slide>> revivedSlidesForCue(Ref ref, Cue? cue) async {
  return await cue?.getRevivedSlides() ?? [];
}

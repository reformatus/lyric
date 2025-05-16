import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/common/adaptive_page.dart';

import '../../data/cue/cue.dart';
import 'widgets/slide_list.dart';

import 'state.dart';
import 'widgets/slide_view.dart';

class CuePage extends ConsumerWidget {
  const CuePage(this.uuid, {this.initialSlideUuid, super.key});

  final String uuid;
  final String? initialSlideUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Cue cue = ref.watch(currentCueProvider)!;
    var slideIndex = ref.watch(watchSlideIndexProvider).valueOrNull;

    return AdaptivePage(
      title: cue.title,
      body: SlideView(),
      leftDrawer: SlideList(cue: cue),
      actionBarChildren: [
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed:
              () => ref.read(currentSlideProvider.notifier).changeSlide(-1),
          icon: const Icon(Icons.navigate_before),
          tooltip: 'Előző dia',
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed:
              () => ref.read(currentSlideProvider.notifier).changeSlide(1),
          icon: const Icon(Icons.navigate_next),
          tooltip: 'Következő dia',
        ),
        const SizedBox(width: 16),
        Text(
          '${(slideIndex?.index ?? 0) + 1}. / ${slideIndex?.total} dia',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

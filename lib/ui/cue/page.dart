import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/common/adaptive_page/page.dart';

import '../../data/cue/cue.dart';
import 'widgets/slide_list.dart';

import 'state.dart';
import 'widgets/slide_view.dart';

class CuePage extends ConsumerWidget {
  const CuePage(this.cue, {this.initialSlideUuid, super.key});

  final Cue cue;
  final String? initialSlideUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var slideIndex = ref.watch(watchSlideIndexOfCueProvider(cue)).valueOrNull;

    return AdaptivePage(
      title: cue.title,
      body: SlideView(cue),
      leftDrawer: SlideList(cue: cue),
      leftDrawerIcon: Icons.list,
      leftDrawerTooltip: 'Lista',
      actionBarChildren: [
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed:
              () => ref
                  .read(currentSlideOfProvider(cue).notifier)
                  .changeSlide(-1),
          icon: const Icon(Icons.navigate_before),
          tooltip: 'Előző dia',
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed:
              () =>
                  ref.read(currentSlideOfProvider(cue).notifier).changeSlide(1),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/ui/base/songs/page.dart';
import 'package:lyric/ui/common/adaptive_page/page.dart';
import 'package:lyric/ui/cue/widgets/actions_drawer.dart';
import 'package:lyric/ui/song/transpose/widget.dart';

import '../../../data/cue/cue.dart';
import '../widgets/slide_list.dart';

import '../state.dart';
import '../widgets/slide_view.dart';

class CueEditPage extends ConsumerWidget {
  const CueEditPage(this.cue, {super.key});

  final Cue cue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var slideIndex = ref.watch(watchSlideIndexOfCueProvider(cue)).valueOrNull;

    return AdaptivePage(
      title: cue.title,
      body: SlideView(cue),
      leftDrawer: SlideList(cue: cue),
      leftDrawerIcon: Icons.list,
      leftDrawerTooltip: 'Lista',
      rightDrawer: ActionsDrawer(cue),
      rightDrawerIcon: Icons.more_vert,
      rightDrawerTooltip: 'Opciók',
      actionBarChildren: [
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed:
              hasPreviousSlide(slideIndex)
                  ? () => ref
                      .read(currentSlideOfProvider(cue).notifier)
                      .changeSlide(-1)
                  : null,
          icon: const Icon(Icons.navigate_before),
          tooltip: 'Előző dia',
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed:
              hasNextSlide(slideIndex)
                  ? () => ref
                      .read(currentSlideOfProvider(cue).notifier)
                      .changeSlide(1)
                  : null,
          icon: const Icon(Icons.navigate_next),
          tooltip: 'Következő dia',
        ),
        const SizedBox(width: 16),
        Text(
          '${(slideIndex?.index ?? 0) + 1}. / ${slideIndex?.total} dia',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
      actionBarTrailingChildren: [
        // far future todo: dropdown for different projection modes
        IconButton.filled(
          tooltip: 'Teljes képernyő',
          onPressed: () => context.push('/cue/${cue.uuid}/present/musician'),
          icon: Icon(Icons.fullscreen),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
    );
  }
}

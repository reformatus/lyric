import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/adaptive_page/page.dart';
import '../widgets/actions_drawer.dart';

import '../../../services/app_links/get_shareable.dart';
import '../../common/share/dialog.dart';
import '../widgets/slide_list.dart';

import '../session/cue_session.dart';
import '../session/session_provider.dart';
import '../state.dart';
import '../widgets/slide_view.dart';

class CueEditPage extends ConsumerWidget {
  const CueEditPage(this.session, {super.key});

  final CueSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slideIndex = ref.watch(slideIndexProvider);
    return AdaptivePage(
      title: session.cue.title,
      subtitle:
          session.cue.description.isNotEmpty ? session.cue.description : null,
      body: const SlideView(),
      leftDrawer: const SlideList(),
      leftDrawerIcon: Icons.list,
      leftDrawerTooltip: 'Lista',
      rightDrawer: const ActionsDrawer(),
      rightDrawerIcon: Icons.more_vert,
      rightDrawerTooltip: 'Opciók',
      actionBarChildren: [
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: hasPreviousSlide(slideIndex)
              ? () => ref
                    .read(activeCueSessionProvider.notifier)
                    .navigate(-1)
              : null,
          icon: const Icon(Icons.navigate_before),
          tooltip: 'Előző dia',
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: hasNextSlide(slideIndex)
              ? () => ref
                    .read(activeCueSessionProvider.notifier)
                    .navigate(1)
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
        IconButton.filledTonal(
          onPressed: () => showShareDialog(
            context,
            title: 'Lista megosztása',
            description:
                'Mutasd meg a kódot vagy küldd el a linket valakinek. A megosztott lista a listái közé kerül (vagy frissül, ha korábban már megnyitotta).',
            sharedTitle: session.cue.title,
            sharedDescription: session.cue.description.isEmpty
                ? null
                : session.cue.description,
            sharedLink: getShareableLinkFor(session.cue),
            sharedIcon: Icons.list,
          ),
          icon: Icon(Icons.share),
          tooltip: 'Megosztási lehetőségek',
        ),
        SizedBox(width: 8),
        // far future todo: dropdown for different projection modes
        IconButton.filled(
          tooltip: 'Teljes képernyő',
          onPressed: () => context.push(
            '/cue/${session.cue.uuid}/present/musician',
          ),
          icon: Icon(Icons.fullscreen),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        SizedBox(width: 8),
      ],
    );
  }
}

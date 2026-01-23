import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'present/musician/page.dart';
import '../common/error/card.dart';
import 'edit/page.dart';
import 'session/cue_session.dart';
import 'session/session_provider.dart';
import 'state.dart';

/// Loader widget that initializes the cue and slide state before rendering any CuePage
class CueLoaderPage extends ConsumerWidget {
  const CueLoaderPage(
    this.uuid,
    this.pageType, {
    this.initialSlideUuid,
    super.key,
  });

  final String uuid;
  final CuePageType pageType;
  final String? initialSlideUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(activeCueSessionProvider);
    final currentUuid = sessionAsync.value?.cue.uuid;

    if (currentUuid != uuid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(activeCueSessionProvider.notifier)
            .load(uuid, initialSlideUuid: initialSlideUuid);
      });
    }

    return sessionAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Hiba')),
        body: Center(
          child: LErrorCard(
            type: LErrorType.error,
            title: 'Nem sikerült betölteni a listát',
            icon: Icons.error,
            message: error.toString(),
            stack: stack.toString(),
          ),
        ),
      ),
      data: (session) {
        if (session == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return buildPage(session);
      },
    );
  }

  Widget buildPage(CueSession session) {
    switch (pageType) {
      case CuePageType.edit:
        return CueEditPage(session);
      case CuePageType.musician:
        return CuePresentMusicianPage(session);
    }
  }
}

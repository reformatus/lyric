import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/cue/present/musician/page.dart';
import '../../data/cue/cue.dart';
import '../common/error/card.dart';
import 'edit/page.dart';
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
    if (!ref.read(currentCueProvider.notifier).isCurrent(uuid)) {
      return buildPage(ref.read(currentCueProvider)!);
    }
    return FutureBuilder(
      future: ref
          .read(currentCueProvider.notifier)
          .load(uuid, initialSlideUuid: initialSlideUuid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Hiba')),
            body: Center(
              child: LErrorCard(
                type: LErrorType.error,
                title: 'Nem sikerült betölteni a listát',
                icon: Icons.error,
                message: snapshot.error.toString(),
                stack: snapshot.stackTrace?.toString() ?? '',
              ),
            ),
          );
        } else {
          Cue cue = snapshot.requireData;
          return buildPage(cue);
        }
      },
    );
  }

  Widget buildPage(Cue cue) {
    switch (pageType) {
      case CuePageType.edit:
        return CueEditPage(cue);
      case CuePageType.musician:
        return CuePresentMusicianPage(cue);
    }
  }
}

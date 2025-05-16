import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/cue/cue.dart';
import '../../services/cue/from_uuid.dart';
import '../common/error/card.dart';
import 'page.dart';
import 'state.dart';

/// Loader widget that initializes the cue and slide state before rendering the CuePage
class CuePageLoader extends ConsumerWidget {
  const CuePageLoader(this.uuid, {this.initialSlideUuid, super.key});

  final String uuid;
  final String? initialSlideUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: _initializeState(ref),
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
          return CuePage(
            snapshot.requireData,
            initialSlideUuid: initialSlideUuid,
          );
        }
      },
    );
  }

  Future<Cue> _initializeState(WidgetRef ref) async {
    final cue = await ref.read(watchCueWithUuidProvider(uuid).future);

    await ref.read(currentSlideListOfProvider(cue).notifier).loadSlides();

    // Set current slide based on initialSlideUuid or default to first slide
    if (initialSlideUuid != null) {
      await ref
          .read(currentSlideOfProvider(cue).notifier)
          .setCurrentWithUuid(initialSlideUuid!);
    } else {
      await ref.read(currentSlideOfProvider(cue).notifier).setFirst();
    }

    return cue;
  }
}

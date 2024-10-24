import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/song/view.dart';

import '../../data/song/song.dart';
import '../../services/songs/filter.dart';
import '../common/error.dart';

class SongPage extends ConsumerWidget {
  const SongPage(this.songUuid, {super.key});

  final String songUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSongs = ref.watch(allSongsProvider);

    Song? song = allSongs.value?.firstWhere((song) => song.uuid == songUuid);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(song?.contentMap['title'] ?? ""),
      ),
      body: switch (allSongs) {
        AsyncError(:final error, :final stackTrace) => Center(
            child: LErrorCard(
              type: LErrorType.error,
              title: 'Hiba a dal betöltése közben',
              message: error.toString(),
              stack: stackTrace.toString(),
              icon: Icons.error,
            ),
          ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncValue() => SongView(song!),
      },
    );
  }
}

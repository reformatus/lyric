import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/data/bank/bank.dart';
import 'package:queue/queue.dart';

import '../../data/bank/provider.dart';

class LoadingPage extends ConsumerWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protoSongs = ref.watch(protoSongListProvider(defaultBanks[1])); // todo all banks
    Queue? protoSongsQueue;
    if (protoSongs.hasValue) {
      protoSongsQueue = ref.watch(protoSongQueueProvider(protoSongs.asData!.value, defaultBanks[1]));
    }

    ref.watch(remainingSongsCountProvider(protoSongsQueue)); // update page every time the queue changes

    protoSongsQueue?.onComplete.then((_) {
      // ignore: use_build_context_synchronously
      context.go('/bank');
    });

    int protoSongsLengthValue() => protoSongs.asData?.value.length ?? 0;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Sófár Lyric'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: protoSongs.when(
                data: (_) => (defaultBanks[1].songs.length) / protoSongsLengthValue(),
                error: (_, __) => 0,
                loading: () => 0,
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: CircularProgressIndicator(
                value: protoSongs.when(
                  data: (_) => (defaultBanks[1].songs.length) / protoSongsLengthValue(),
                  error: (_, __) => 0,
                  loading: () => null,
                ),
              ),
              title: Text(
                '${defaultBanks[1].name}\nletöltése folyamatban...',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: protoSongs.hasValue
                  ? Text(
                      '${defaultBanks[1].songs.length} / ${protoSongs.asData!.value.length}',
                    )
                  : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

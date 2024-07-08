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
    final protoSongs = ref.watch(protoSongListProvider(defaultBanks[1]));
    Queue? protoSongsQueue;
    if (protoSongs.hasValue) {
      protoSongsQueue = ref.watch(
          protoSongQueueProvider(protoSongs.asData!.value, defaultBanks[1]));
    }
    final remainingSongCount =
        ref.watch(remainingSongsCountProvider(protoSongsQueue));

    protoSongsQueue?.onComplete.then((_) {
      context.go('/bank');
    });

    return Scaffold(
      appBar: AppBar(
          title: const Text('Sófár Lyric'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: protoSongs.when(
                data: (_) =>
                    ((protoSongs.asData?.value.length ?? 0) -
                        (remainingSongCount.asData?.value ?? 0).toDouble()) /
                    (protoSongs.asData?.value.length ??
                        0), // TODO put inside variable
                error: (_, __) => 1,
                loading: () => null as double?,
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${defaultBanks[1].name}\nletöltése folyamatban...',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (protoSongs.hasValue) ...[
              Text(
                '${(protoSongs.asData?.value.length ?? 0) - (remainingSongCount.asData?.value ?? 0)} / ${protoSongs.asData?.value.length ?? '!!!'}',
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/bank/bank.dart';

import '../../data/bank/provider.dart';

class LoadingPage extends ConsumerWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protoSongs = ref.watch(protoSongListProvider(defaultBanks.first));

    return Scaffold(
      appBar: AppBar(
          title: const Text('Sófár Lyric'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: protoSongs.when(
                data: (_) => 0.5,
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
              'Énektár letöltése folyamatban...',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (protoSongs.hasValue) ...[
              Text(
                '0 / ${protoSongs.asData?.value.length ?? '!!!'}',
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

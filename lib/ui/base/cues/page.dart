import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/services/cue/cues.dart';
import 'package:lyric/ui/common/error.dart';

import '../../../data/cue/cue.dart';

class SetsPage extends ConsumerStatefulWidget {
  const SetsPage({super.key});

  @override
  ConsumerState<SetsPage> createState() => _SetsPageState();
}

class _SetsPageState extends ConsumerState<SetsPage> {
  @override
  Widget build(BuildContext context) {
    final cues = ref.watch(getAllCuesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Listáim'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Új lista'),
        icon: Icon(Icons.playlist_add),
      ),
      body: switch (cues) {
        AsyncError(:final error, :final stackTrace) => Center(
            child: LErrorCard(
              type: LErrorType.error,
              title: 'Hová lettek a listák?',
              icon: Icons.error,
              message: error.toString(),
              stack: stackTrace.toString(),
            ),
          ),
        AsyncLoading() => Center(child: CircularProgressIndicator()),
        AsyncValue(:final value) => ListView(
            children: value!.map((e) => CueTile(e)).toList(),
          ),
      },
    );
  }
}

class CueTile extends StatelessWidget {
  const CueTile(
    this.cue, {
    super.key,
  });

  final Cue cue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cue.title),
      subtitle: Text(cue.description),
      onTap: () => context.push('/cue/${cue.id}'),
    );
  }
}
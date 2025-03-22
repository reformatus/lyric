import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/ui/common/centered_hint.dart';

import '../../../data/cue/cue.dart';
import '../../../services/cue/cues.dart';
import '../../common/error/card.dart';
import 'dialogs.dart';

class SetsPage extends ConsumerStatefulWidget {
  const SetsPage({super.key});

  @override
  ConsumerState<SetsPage> createState() => _SetsPageState();
}

class _SetsPageState extends ConsumerState<SetsPage> {
  @override
  Widget build(BuildContext context) {
    final cues = ref.watch(watchAllCuesProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Listáim')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => showAdaptiveDialog(
              context: context,
              builder: (context) => EditCueDialog(),
            ),
        label: Text('Új lista'),
        icon: Icon(Icons.add_box_outlined),
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
        AsyncValue(:final value!) =>
          value.isNotEmpty
              ? ListView(children: value.map((e) => CueTile(e)).toList())
              : Center(
                child: CenteredHint(
                  'Adj hozzá egy listát a jobb alsó sarokban!',
                  Icons.add_box_outlined,
                ),
              ),
      },
    );
  }
}

class CueTile extends StatelessWidget {
  const CueTile(this.cue, {super.key});

  final Cue cue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cue.title),
      subtitle: cue.description.isNotEmpty ? Text(cue.description) : null,
      onTap: () => context.push('/cue/${cue.uuid}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed:
                () => showAdaptiveDialog(
                  context: context,
                  builder: (context) => EditCueDialog(cue: cue),
                ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed:
                () => showAdaptiveDialog(
                  context: context,
                  builder: (context) => DeleteCueDialog(cue: cue),
                ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Dialog for adding songs to the cue
/// This is a placeholder - you'll implement proper song adding later
class AddSongDialog extends StatelessWidget {
  const AddSongDialog({required this.cueUuid, super.key});

  final String cueUuid;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Songs'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Text(
            'Song adding will be implemented later',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}

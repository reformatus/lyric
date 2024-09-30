import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/song/song.dart';

class LSongTile extends StatelessWidget {
  const LSongTile(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.go('/song/${song.uuid}'),
      title: Text(song.content['title']!),
    );
  }
}

import 'package:flutter/material.dart';

import '../../data/song/song.dart';

class SongView extends StatelessWidget {
  const SongView(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Text(song.content['lyrics'] ?? ''),
    ]);
  }
}

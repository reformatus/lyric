import 'package:flutter/material.dart';
import 'package:lyric/data/bank/bank.dart';
import 'package:lyric/views/song/view.dart';

import '../../data/song/song.dart';

class SongPage extends StatelessWidget {
  const SongPage(this.songUuid, {super.key});

  final String songUuid;

  @override
  Widget build(BuildContext context) {
    Song song = allSongs.firstWhere((song) => song.uuid == songUuid);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(song.content['title']!),
      ),
      body: SongView(song),
    );
  }
}

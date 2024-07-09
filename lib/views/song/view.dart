import 'package:flutter/material.dart';

import '../../data/song/song.dart';

class SongView extends StatelessWidget {
  const SongView(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ListTile(
        subtitle: song.title != song.firstLine
            ? Text(song.firstLine, softWrap: false, overflow: TextOverflow.fade)
            : null,
        trailing: Text(song.genre),
      ),
      const Divider(),
      Text(song.lyrics),
    ]);
  }
}

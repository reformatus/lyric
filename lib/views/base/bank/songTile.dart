import 'package:flutter/material.dart';

import '../../../data/song/song.dart';

class LSongTile extends StatelessWidget {
  const LSongTile(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(song.title),
      subtitle: song.title != song.firstLine
          ? Text(song.firstLine, softWrap: false, overflow: TextOverflow.fade)
          : null,
      trailing: Text(song.genre),
    );
  }
}

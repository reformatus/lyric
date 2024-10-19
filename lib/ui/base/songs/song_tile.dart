import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/services/songs/filter.dart';


class LSongTile extends StatelessWidget {
  const LSongTile(this.songResult, {super.key});

  final SongResult songResult;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push('/song/${songResult.song.uuid}'),
      title: Text(songResult.song.content['title']!),
    );
  }
}

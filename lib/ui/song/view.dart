import 'package:flutter/material.dart';
import 'package:lyric/ui/base/songs/filter/multiselect-tags/state.dart';

import '../../data/song/song.dart';

const Set<String> fieldsToShowInDetailsSummary = {
  'composer',
  'poet',
  'translator',
};

const Set<String> fieldsToOmitFromDetails = {
  'lyrics',
  'first_line',
};

class SongView extends StatelessWidget {
  const SongView(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    List<Widget> detailsSummary = [];
    List<Widget> detailsFull = [];

    for (String field in fieldsToShowInDetailsSummary) {
      if (song.contentMap[field] != null && song.contentMap[field]!.isNotEmpty) {
        detailsSummary.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(songFieldsMap[field]!['icon']),
              Padding(
                padding: EdgeInsets.only(left: 3, top: 5, bottom: 5),
                child: Text(song.contentMap[field]!),
              ),
            ],
          ),
        );
      }
    }

    for (MapEntry<String, String> entry in song.contentMap.entries) {
      if (fieldsToOmitFromDetails.contains(entry.key)) continue;
      if (entry.value.isNotEmpty) {
        if (songFieldsMap.containsKey(entry.key)) {
          detailsFull.add(ListTile(
            visualDensity: VisualDensity.compact,
            leading: Icon(songFieldsMap[entry.key]!['icon']),
            title: Text(
              songFieldsMap[entry.key]!['title_hu'],
              style: Theme.of(context).primaryTextTheme.labelMedium,
            ),
            subtitle: Text(entry.value),
            subtitleTextStyle: Theme.of(context).listTileTheme.titleTextStyle,
          ));
        } else {
          // return compatibility listtile
        }
      }
    }

    return ListView(children: [
      ExpansionTile(
        title: Wrap(
          spacing: 10,
          children: detailsSummary,
        ),
        children: detailsFull,
      ),
      Text(song.contentMap['lyrics'] ?? ''),
    ]);
  }
}

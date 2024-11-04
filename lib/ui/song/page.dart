import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/database.dart';
import 'package:lyric/services/song/from_uuid.dart';
import 'package:lyric/ui/song/sheet/view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/song/song.dart';
import '../../services/songs/filter.dart';
import '../base/songs/filter/multiselect-tags/state.dart';
import '../common/error.dart';

const Set<String> fieldsToShowInDetailsSummary = {
  'composer',
  'poet',
  'translator',
};

const Set<String> fieldsToOmitFromDetails = {
  'lyrics',
  'first_line',
};

class SongPage extends ConsumerWidget {
  const SongPage(this.songUuid, {super.key});

  final String songUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(songFromUuidProvider(songUuid));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(song.value?.contentMap['title'] ?? ''),
      ),
      body: switch (song) {
        AsyncError(:final error, :final stackTrace) => Center(
            child: LErrorCard(
              type: LErrorType.error,
              title: 'Hiba a dal betöltése közben',
              message: error.toString(),
              stack: stackTrace.toString(),
              icon: Icons.error,
            ),
          ),
        AsyncLoading() => const Center(child: CircularProgressIndicator(value: 0.3)),
        AsyncValue(:final value!) => Column(
            children: [
              ExpansionTile(
                title: Wrap(
                  spacing: 10,
                  // todo handle not showing any entries
                  children: getDetailsSummaryContent(value),
                ),
                children: getDetailsContent(value, context),
              ),
              Expanded(child: Center(child: SheetView(value))),
            ],
          ),
      },
    );
  }

  List<Widget> getDetailsSummaryContent(Song song) {
    List<Widget> detailsSummary = [];
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
    return detailsSummary;
  }

  List<Widget> getDetailsContent(Song song, BuildContext context) {
    List<Widget> detailsContent = [];
    for (MapEntry<String, String> contentEntry in song.contentMap.entries) {
      if (fieldsToOmitFromDetails.contains(contentEntry.key)) continue;
      if (contentEntry.value.isNotEmpty) {
        if (songFieldsMap.containsKey(contentEntry.key)) {
          detailsContent.add(ListTile(
            visualDensity: VisualDensity.compact,
            leading: Icon(songFieldsMap[contentEntry.key]!['icon']),
            title: Text(
              songFieldsMap[contentEntry.key]!['title_hu'],
              style: Theme.of(context).primaryTextTheme.labelMedium,
            ),
            subtitle: Text(contentEntry.value),
            subtitleTextStyle: Theme.of(context).listTileTheme.titleTextStyle,
          ));
        } else {
          // return compatibility listtile
        }
      }
    }
    return detailsContent;
  }
}

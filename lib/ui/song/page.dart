import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lyrics/state.dart';
import 'lyrics/view.dart';
import 'sheet/view.dart';

import '../../data/song/song.dart';
import '../../services/song/from_uuid.dart';
import '../base/songs/filter/types/field_type.dart';
import '../common/error.dart';

import 'state.dart';

const Set<String> fieldsToShowInDetailsSummary = {'composer', 'lyricist', 'translator'};

const Set<String> fieldsToOmitFromDetails = {'lyrics', 'first_line'};

class SongPage extends ConsumerStatefulWidget {
  const SongPage(this.songUuid, {super.key});

  final String songUuid;

  @override
  ConsumerState<SongPage> createState() => _SongPageState();
}

class _SongPageState extends ConsumerState<SongPage> {
  @override
  void initState() {
    detailsSheetScrollController = ScrollController();
    super.initState();
  }

  late final ScrollController detailsSheetScrollController;
  bool detailsRowShown = true;

  @override
  Widget build(BuildContext context) {
    final song = ref.watch(songFromUuidProvider(widget.songUuid));
    final showLyrics = ref.watch(showLyricsProvider);
    final transposeAmount = ref.watch(transposeStateProvider);

    final List<Widget> summaryContent = song.when(
      data: (song) => getDetailsSummaryContent(song),
      loading: () => [],
      error: (_, _) => [],
    );

    final List<Widget> detailsContent = song.when(
      data: (song) => getDetailsContent(song, context),
      loading: () => [],
      error: (_, _) => [],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        var isHorizontal = constraints.maxHeight < constraints.maxWidth;
        return Scaffold(
          backgroundColor: Theme.of(context).indicatorColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(song.value?.contentMap['title'] ?? ''),
            actions: [
              if (detailsContent.isNotEmpty && constraints.maxWidth > 500)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth / 2),
                  child: detailsButton(summaryContent, context, detailsContent),
                ),
            ],
          ),
          body: Flex(
            direction: isHorizontal ? Axis.horizontal : Axis.vertical,
            children: [
              Expanded(
                child: switch (song) {
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
                      if (detailsContent.isNotEmpty && constraints.maxWidth <= 500)
                        Align(
                          alignment: Alignment.centerRight,
                          child: detailsButton(summaryContent, context, detailsContent),
                        ),
                      if (showLyrics)
                        Expanded(child: LyricsView(value))
                      else
                        Expanded(child: Center(child: SheetView(value))),
                    ],
                  ),
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Flex(
                  direction: isHorizontal ? Axis.vertical : Axis.horizontal,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => ref.read(showLyricsProvider.notifier).toggle(),
                      label: showLyrics ? Text('Kotta') : Text('Dalszöveg'),
                      icon: Icon(showLyrics ? Icons.music_video : Icons.description_outlined),
                    ),
                    if (showLyrics) ...[
                      IconButton.filledTonal(
                        onPressed: () => ref.read(transposeStateProvider.notifier).decrement(),
                        icon: Icon(Icons.arrow_downward),
                      ),
                      Text(transposeAmount.toString()),
                      IconButton.filledTonal(
                        onPressed: () => ref.read(transposeStateProvider.notifier).increment(),
                        icon: Icon(Icons.arrow_upward),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget detailsButton(List<Widget> summaryContent, BuildContext context, List<Widget> detailsContent) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: Theme.of(context).primaryTextTheme.labelMedium!,
          foregroundColor: Theme.of(context).colorScheme.secondary,
        ),
        child: Wrap(spacing: 10, children: summaryContent.isNotEmpty ? summaryContent : [Text('Részletek')]),
        onPressed: () => showDetailsBottomSheet(context, detailsSheetScrollController, detailsContent),
      ),
    );
  }

  Future<dynamic> showDetailsBottomSheet(
    BuildContext context,
    ScrollController detailsSheetScrollController,
    List<Widget> detailsContent,
  ) {
    return showModalBottomSheet(
      // todo factor out to general bottom sheet that can be used troughout the app
      // todo use https://pub.dev/packages/wtf_sliding_sheet or similar
      // far future todo consider other view type for desktop
      context: context,
      builder:
          (_) => FadingEdgeScrollView.fromScrollView(
            child: ListView(
              controller: detailsSheetScrollController,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close)),
                  ),
                ),
                ...detailsContent,
              ],
            ),
          ),
      isScrollControlled: true,
      useRootNavigator: false,
      scrollControlDisabledMaxHeightRatio: 0.5,
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
              Icon(songFieldsMap[field]!['icon'], color: Theme.of(context).colorScheme.secondary),
              SizedBox(width: 3),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  song.contentMap[field]!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                ),
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
          detailsContent.add(
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(songFieldsMap[contentEntry.key]!['icon']),
              title: Text(
                songFieldsMap[contentEntry.key]!['title_hu'],
                style: Theme.of(context).primaryTextTheme.labelMedium,
              ),
              subtitle: Text(contentEntry.value),
              subtitleTextStyle: Theme.of(context).listTileTheme.titleTextStyle,
            ),
          );
        } else {
          // return compatibility listtile
        }
      }
    }
    return detailsContent;
  }
}

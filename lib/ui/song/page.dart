import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/song/extensions.dart';
import 'package:lyric/main.dart';
import 'package:lyric/services/key/get_transposed.dart';
import 'package:lyric/ui/song/transpose/widget.dart';
import 'transpose/state.dart';
import 'lyrics/view.dart';
import 'sheet/view.dart';

import '../../data/song/song.dart';
import '../../services/song/from_uuid.dart';
import '../base/songs/filter/types/field_type.dart';
import '../common/error.dart';
import 'state.dart';

// far future read from songbank introduction
const Set<String> fieldsToShowInDetailsSummary = {
  'composer',
  'lyricist',
  'translator',
};
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
    _detailsSheetScrollController = ScrollController();
    _transposeOverlayPortalController = OverlayPortalController();

    super.initState();
  }

  late final ScrollController _detailsSheetScrollController;
  late final OverlayPortalController _transposeOverlayPortalController;

  final _transposeOverlayLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    final song = ref.watch(songFromUuidProvider(widget.songUuid));

    return switch (song) {
      AsyncLoading() => Center(child: CircularProgressIndicator()),
      AsyncError(:final error, :final stackTrace) => Center(
        child: LErrorCard(
          type: LErrorType.error,
          title: 'Nem sikerült betölteni a dalt :(',
          message: error.toString(),
          stack: stackTrace.toString(),
          icon: Icons.music_note,
        ),
      ),
      AsyncValue(value: null) => Center(
        child: LErrorCard(
          type: LErrorType.info,
          title: 'Úgy tűnik, ez a dal nincs a táradban...',
          icon: Icons.search_off,
        ),
      ),
      AsyncValue(value: final Song song) => LayoutBuilder(
        builder: (context, constraints) {
          var isDesktop =
              (constraints.maxHeight < constraints.maxWidth) &&
              constraints.maxWidth > globals.desktopFromWidth;
          var isMobile = constraints.maxWidth < 400;

          final List<Widget> summaryContent = getDetailsSummaryContent(song);
          final List<Widget> detailsContent = getDetailsContent(song, context);
          /* // TODO set initial tab
          late final SongViewType initialType;
          if (song.hasSvg) {
            initialType = SongViewType.svg;
          } else if (song.hasPdf) {
            initialType = SongViewType.pdf;
          } else {
            initialType = SongViewType.lyrics;
          }

          ref
              .read(ViewTypeForProvider(song.uuid).notifier)
              .changeTo(initialType);
*/
          final viewType = ref.watch(ViewTypeForProvider(song.uuid));
          final transpose = ref.watch(TransposeStateForProvider(song.uuid));

          return Scaffold(
            backgroundColor: Theme.of(context).indicatorColor,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(song.contentMap['title'] ?? ''),
              actions: [
                if (isDesktop)
                  ViewChooser(
                    viewType: viewType,
                    song: song,
                    useDropdown: false,
                  ),
                if ((detailsContent.isNotEmpty && !isDesktop) && !isMobile)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth / 2.5,
                    ),
                    child: detailsButton(
                      summaryContent,
                      context,
                      detailsContent,
                    ),
                  ),
                SizedBox(width: 10),
              ],
            ),
            body: Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: switch (viewType) {
                    SongViewType.svg => SheetView.svg(song),
                    SongViewType.pdf => SheetView.pdf(song),
                    SongViewType.lyrics => LyricsView(song),
                  },
                ),
                if (isMobile)
                  detailsButton(summaryContent, context, detailsContent),
                if (isDesktop)
                  SizedBox(
                    width: (constraints.maxWidth / 5).clamp(200, 350),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (viewType == SongViewType.lyrics &&
                                song.hasChords) ...[
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 200),
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          child: Row(
                                            children: [
                                              if (song.keyField != null)
                                                Text(
                                                  getTransposedKey(
                                                    song.keyField!,
                                                    transpose.semitones,
                                                  ).toString(),
                                                  style:
                                                      Theme.of(
                                                        context,
                                                      ).textTheme.bodyLarge,
                                                ),
                                              TransposeResetButton(
                                                song,
                                                isHorizontal: isDesktop,
                                              ),
                                            ],
                                          ),
                                        ),
                                        TransposeControls(song),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                            ...detailsContent,
                          ],
                        ),
                      ),
                    ),
                  ),
                if (!isDesktop)
                  SizedBox(
                    height: 50,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        children: [
                          ViewChooser(
                            viewType: viewType,
                            song: song,
                            useDropdown: constraints.maxWidth < 550,
                          ),
                          if (viewType == SongViewType.lyrics &&
                              song.hasChords) ...[
                            Spacer(),
                            TransposeResetButton(song, isHorizontal: isDesktop),
                            CompositedTransformTarget(
                              link: _transposeOverlayLink,
                              child: OverlayPortal(
                                controller: _transposeOverlayPortalController,
                                overlayChildBuilder:
                                    (context) => CompositedTransformFollower(
                                      link: _transposeOverlayLink,
                                      followerAnchor: Alignment.bottomRight,
                                      targetAnchor: Alignment.topRight,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Card(
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: 150,
                                              ),
                                              child: TransposeControls(song),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                child: FilledButton.tonalIcon(
                                  onPressed: () {
                                    _transposeOverlayPortalController.toggle();
                                    setState(() {});
                                  },
                                  label: Text(
                                    song.keyField != null
                                        ? getTransposedKey(
                                          song.keyField!,
                                          transpose.semitones,
                                        ).toString()
                                        : 'Transzponálás',
                                  ),
                                  icon: Icon(
                                    _transposeOverlayPortalController.isShowing
                                        ? Icons.close
                                        : Icons.unfold_more,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    };
  }

  Widget detailsButton(
    List<Widget> summaryContent,
    BuildContext context,
    List<Widget> detailsContent,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: Theme.of(context).primaryTextTheme.labelMedium!,
          foregroundColor: Theme.of(context).colorScheme.secondary,
        ),
        child: Wrap(
          spacing: 10,
          children:
              summaryContent.isNotEmpty ? summaryContent : [Text('Részletek')],
        ),
        onPressed:
            () => showDetailsBottomSheet(
              context,
              _detailsSheetScrollController,
              detailsContent,
            ),
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
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close),
                    ),
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
      if (song.contentMap[field] != null &&
          song.contentMap[field]!.isNotEmpty) {
        detailsSummary.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                songFieldsMap[field]!['icon'],
                color: Theme.of(context).colorScheme.secondary,
              ),
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

class ViewChooser extends ConsumerWidget {
  const ViewChooser({
    super.key,
    required this.viewType,
    required this.song,
    required this.useDropdown,
  });

  final SongViewType viewType;
  final Song song;
  final bool useDropdown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<
      ({SongViewType value, IconData icon, String label, bool enabled})
    >
    viewTypeEntries = [
      (
        value: SongViewType.svg,
        icon: Icons.music_note_outlined,
        label: 'Kotta',
        enabled: song.hasSvg,
      ),
      (
        value: SongViewType.pdf,
        icon: Icons.audio_file_outlined,
        label: 'PDF',
        enabled: song.hasPdf,
      ),
      (
        value: SongViewType.lyrics,
        icon: song.hasChords ? Icons.tag_outlined : Icons.text_snippet_outlined,
        label: song.hasChords ? 'Akkordok' : 'Dalszöveg',
        enabled: song.hasLyrics,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!useDropdown) {
          return SegmentedButton<SongViewType>(
            selected: {viewType},
            onSelectionChanged: (viewTypeSet) {
              ref
                  .read(ViewTypeForProvider(song.uuid).notifier)
                  .changeTo(viewTypeSet.first);
            },
            showSelectedIcon: false,
            multiSelectionEnabled: false,
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ),
            segments:
                viewTypeEntries
                    .map(
                      (e) => ButtonSegment(
                        value: e.value,
                        label: Text(e.label),
                        icon: Icon(e.icon),
                        enabled: e.enabled,
                        tooltip: !e.enabled ? 'Nem elérhető' : null,
                      ),
                    )
                    .toList(),
          );
        } else {
          return DropdownButtonHideUnderline(
            child: DropdownButton<SongViewType>(
              value: viewType,
              onChanged:
                  (viewType) => ref
                      .read(ViewTypeForProvider(song.uuid).notifier)
                      .changeTo(viewType!),
              items:
                  viewTypeEntries
                      .where((e) => e.enabled)
                      .map(
                        (e) => DropdownMenuItem(
                          enabled: e.enabled,
                          value: e.value,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(e.icon),
                              ),
                              Text(e.label),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          );
        }
      },
    );
  }
}

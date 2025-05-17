import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import '../../data/cue/slide.dart';

import '../../data/song/extensions.dart';
import '../../data/song/song.dart';
import '../../main.dart';
import '../../services/key/get_transposed.dart';
import '../../services/song/from_uuid.dart';
import '../base/songs/filter/types/field_type.dart';
import '../common/error/card.dart';
import 'add_to_cue_search.dart';
import 'lyrics/view.dart';
import 'sheet/view.dart';
import 'state.dart';
import 'transpose/state.dart';
import 'transpose/widget.dart';
import 'view_chooser.dart';

// far future read from songbank introduction
const Set<String> fieldsToShowInDetailsSummary = {
  'composer',
  'lyricist',
  'translator',
};
const Set<String> fieldsToOmitFromDetails = {'tite', 'opensong', 'first_line'};

class SongPage extends ConsumerStatefulWidget {
  const SongPage(this.songId, {this.songSlide, super.key});
  final String songId;
  final SongSlide? songSlide;

  @override
  ConsumerState<SongPage> createState() => _SongPageState();
}

class _SongPageState extends ConsumerState<SongPage> {
  @override
  void initState() {
    detailsSheetScrollController = ScrollController();
    transposeOverlayPortalController = OverlayPortalController();
    actionButtonsScrollController = ScrollController();

    super.initState();
  }

  late final ScrollController detailsSheetScrollController;
  late final ScrollController actionButtonsScrollController;
  late final OverlayPortalController transposeOverlayPortalController;

  final _transposeOverlayLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    final song = ref.watch(songFromUuidProvider(widget.songId));

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

          final viewType = ref.watch(
            ViewTypeForProvider(song.uuid, widget.songSlide),
          );
          final transpose = ref.watch(
            TransposeStateForProvider(song.uuid, widget.songSlide),
          );

          if (viewType == null) {
            ref
                .read(viewTypeForProvider(song.uuid, widget.songSlide).notifier)
                .setDefaultFor(song);
            return Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
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
                    songSlide: widget.songSlide,
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
                    SongViewType.lyrics => LyricsView(
                      song,
                      transposeOptional: transpose,
                    ),
                  },
                ),
                if (isMobile)
                  detailsButton(summaryContent, context, detailsContent),
                //! Sidebar for desktop
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
                                              Text(
                                                song.keyField != null
                                                    ? getTransposedKey(
                                                      song.keyField!,
                                                      transpose.semitones,
                                                    ).toString()
                                                    : 'Hangnem',
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodyLarge,
                                              ),
                                              TransposeResetButton(
                                                song,
                                                songSlide: widget.songSlide,
                                                isHorizontal: isDesktop,
                                              ),
                                            ],
                                          ),
                                        ),
                                        TransposeControls(
                                          song,
                                          songSlide: widget.songSlide,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            AddToCueSearch(
                              song: song,
                              isDesktop: isDesktop,
                              viewType: viewType,
                              transpose: transpose,
                            ),
                            Divider(),
                            ...detailsContent,
                          ],
                        ),
                      ),
                    ),
                  ),
                //! Bottom bar for mobile/tablet
                if (!isDesktop)
                  SizedBox(
                    height: 50,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ViewChooser(
                            viewType: viewType,
                            song: song,
                            songSlide: widget.songSlide,
                            useDropdown: constraints.maxWidth < 550,
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: FadingEdgeScrollView.fromScrollView(
                                  child: ListView(
                                    controller: actionButtonsScrollController,
                                    scrollDirection: Axis.horizontal,
                                    reverse: true,
                                    shrinkWrap: true,
                                    children:
                                        [
                                          AddToCueSearch(
                                            song: song,
                                            isDesktop: isDesktop,
                                            viewType: viewType,
                                            transpose: transpose,
                                          ),
                                          if (viewType == SongViewType.lyrics &&
                                              song.hasChords) ...[
                                            VerticalDivider(),
                                            TransposeResetButton(
                                              song,
                                              songSlide: widget.songSlide,
                                              isHorizontal: isDesktop,
                                            ),
                                            CompositedTransformTarget(
                                              link: _transposeOverlayLink,
                                              child: OverlayPortal(
                                                controller:
                                                    transposeOverlayPortalController,
                                                overlayChildBuilder:
                                                    (
                                                      context,
                                                    ) => CompositedTransformFollower(
                                                      link:
                                                          _transposeOverlayLink,
                                                      followerAnchor:
                                                          Alignment.bottomRight,
                                                      targetAnchor:
                                                          Alignment.topRight,
                                                      child: Align(
                                                        alignment:
                                                            Alignment
                                                                .bottomRight,
                                                        child: Card(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  10,
                                                                ),
                                                            child: ConstrainedBox(
                                                              constraints:
                                                                  BoxConstraints(
                                                                    maxWidth:
                                                                        150,
                                                                  ),
                                                              child: TransposeControls(
                                                                song,
                                                                songSlide:
                                                                    widget
                                                                        .songSlide,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                child: FilledButton.tonalIcon(
                                                  onPressed: () {
                                                    transposeOverlayPortalController
                                                        .toggle();
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
                                                    transposeOverlayPortalController
                                                            .isShowing
                                                        ? Icons.close
                                                        : Icons.unfold_more,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ].reversed.toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
              detailsSheetScrollController,
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
    return showSlidingBottomSheet(
      context,
      builder:
          (context) => SlidingSheetDialog(
            avoidStatusBar: true,
            maxWidth: 600,
            cornerRadius: 20,
            dismissOnBackdropTap: true,
            duration: Durations.medium2,
            headerBuilder:
                (context, state) => Padding(
                  padding: EdgeInsets.only(left: 16, right: 8, top: 8),
                  child: Row(
                    children: [
                      Text(
                        'Részletek',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
            builder: (context, state) {
              return Column(children: detailsContent);
            },
          ),
      useRootNavigator: false,
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

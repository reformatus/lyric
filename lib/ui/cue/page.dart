import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/cue/slide.dart';
import 'package:lyric/main.dart';
import 'package:lyric/services/cue/from_uuid.dart';
import 'package:lyric/services/cue/slide/watch_revived.dart';
import 'package:lyric/services/cue/write_cue.dart';
import 'package:lyric/ui/base/songs/page.dart';
import 'package:lyric/ui/common/error.dart';
import 'package:lyric/ui/cue/slide_views/song.dart';

/* // todo improve cue page:
 * move state management to riverpod
 * move slide list to left drawer on mobile
 * make close search consistent with closing slide preview button (using proper state management)
 * factor out repeated code, ternaries, and in-line callback definitions
 * prevent unnecessary ui updates and db reads
 * implement proper presentation view with tap controls
 * implement tap to fullscreen
 * save last selected cue index to db (maybe?)
 */

class CuePage extends ConsumerStatefulWidget {
  const CuePage(this.uuid, {this.initialSlideIndex, super.key});

  final String uuid;
  final int? initialSlideIndex;

  @override
  ConsumerState<CuePage> createState() => _CuePageState();
}

class _CuePageState extends ConsumerState<CuePage> {
  @override
  void initState() {
    selectedSlideOrIsAdding = widget.initialSlideIndex;
    super.initState();
  }

  /// -1 means song adding mode
  /// null means neither song selected nor adding mode
  int? selectedSlideOrIsAdding = 0;
  bool get isSongAddingMode => selectedSlideOrIsAdding == -1;
  bool isSlideViewExpanded = false;

  List<Slide>? localSlides;

  @override
  Widget build(BuildContext context) {
    final cue = ref.watch(watchCueWithUuidProvider(widget.uuid));
    final slides = ref.watch(watchRevivedSlidesForCueWithUuidProvider(widget.uuid));

    slides.whenData((revivedSlides) {
      if (localSlides == null || !cue.isLoading) {
        setState(() {
          localSlides = revivedSlides;
        });
      }
    });

    addSongsModeCallback() {
      setState(() => selectedSlideOrIsAdding = -1);
    }

    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
        child: Flex(
          direction: constraints.maxWidth > globals.tabletFromWidth ? Axis.horizontal : Axis.vertical,
          children: [
            if (!(isSlideViewExpanded && selectedSlideOrIsAdding != null && selectedSlideOrIsAdding != -1))
              Expanded(
                child: Scaffold(
                  appBar: AppBar(title: Text(cue.value?.title ?? '')),
                  // todo show error message when cue provider returns error
                  body: switch (slides) {
                    AsyncError(:final error, :final stackTrace) => LErrorCard(
                        type: LErrorType.error,
                        title: 'Nem sikerült betölteni a lista diáit!',
                        icon: Icons.error,
                        message: error.toString(),
                        stack: stackTrace.toString(),
                      ),
                    AsyncValue(:final value) => value != null
                        ? ListTileTheme(
                            selectedTileColor: Theme.of(context).indicatorColor,
                            child: ReorderableListView(
                              onReorder: (from, to) {
                                setState(() {
                                  final item = localSlides!.removeAt(from);
                                  localSlides!.insert(to > from ? to - 1 : to, item);
                                  reorderCueSlides(cue.requireValue, from, to);
                                  if (selectedSlideOrIsAdding == from) {
                                    selectedSlideOrIsAdding = to > from ? to - 1 : to;
                                  } else if (selectedSlideOrIsAdding != null &&
                                      from <= selectedSlideOrIsAdding! &&
                                      to > selectedSlideOrIsAdding!) {
                                    selectedSlideOrIsAdding = selectedSlideOrIsAdding! - 1;
                                  }
                                });
                              },
                              footer: SizedBox(
                                height: 60,
                              ),
                              children: localSlides!.asMap().entries.map(
                                (indexedEntry) {
                                  selectCallback() {
                                    setState(() {
                                      if (selectedSlideOrIsAdding == indexedEntry.key) {
                                        selectedSlideOrIsAdding = null;
                                      } else {
                                        selectedSlideOrIsAdding = indexedEntry.key;
                                      }
                                    });
                                    // todo update query parameter with selected slide
                                  }

                                  removeCallback() {
                                    if (selectedSlideOrIsAdding == indexedEntry.key) {
                                      setState(() => selectedSlideOrIsAdding = null);
                                    }
                                    if (!isSongAddingMode &&
                                        selectedSlideOrIsAdding != null &&
                                        selectedSlideOrIsAdding! > indexedEntry.key) {
                                      setState(() {
                                        selectedSlideOrIsAdding = selectedSlideOrIsAdding! - 1;
                                      });
                                    }
                                    removeSlideAtIndexFromCue(indexedEntry.key, cue.requireValue);
                                  }

                                  switch (indexedEntry.value) {
                                    case SongSlide songSlide:
                                      return SongSlideTile(
                                        key: Key('${indexedEntry.value}-${songSlide.hashCode}'),
                                        songSlide,
                                        selectCallback: selectCallback,
                                        removeCallback: removeCallback,
                                        selected: indexedEntry.key == selectedSlideOrIsAdding,
                                      );
                                    case UnknownTypeSlide unknownTypeSlide:
                                      return UnknownTypeSlideTile(
                                        key: Key('${indexedEntry.value}-${unknownTypeSlide.hashCode}'),
                                        unknownTypeSlide,
                                        selectCallback: selectCallback,
                                        removeCallback: removeCallback,
                                        selected: indexedEntry.key == selectedSlideOrIsAdding,
                                      );
                                  }
                                },
                              ).toList(),
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),
                  },
                  floatingActionButton: isSongAddingMode
                      ? (constraints.maxWidth <= globals.tabletFromWidth)
                          ? FloatingActionButton.small(
                              onPressed: () => setState(() {
                                selectedSlideOrIsAdding = null;
                              }),
                              tooltip: 'Kereső bezárása',
                              child: Icon(Icons.keyboard_arrow_down),
                            )
                          : null
                      : (constraints.maxWidth > globals.tabletFromWidth || selectedSlideOrIsAdding == null)
                          ? FloatingActionButton.extended(
                              onPressed: addSongsModeCallback,
                              label: Text('Énekek hozzáadása'),
                              icon: Icon(Icons.playlist_add),
                            )
                          : FloatingActionButton.small(
                              onPressed: addSongsModeCallback,
                              tooltip: 'Énekek hozzáadása',
                              child: Icon(Icons.playlist_add),
                            ),
                ),
              ),
            if (selectedSlideOrIsAdding != null && selectedSlideOrIsAdding != -1 && cue.hasValue)
              Expanded(
                flex: 2,
                child: Container(
                  color: Theme.of(context).indicatorColor,
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        height: 56,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            IconButton.filledTonal(
                              onPressed: selectedSlideOrIsAdding! > 0
                                  ? () {
                                      setState(() {
                                        selectedSlideOrIsAdding = selectedSlideOrIsAdding! - 1;
                                      });
                                    }
                                  : null,
                              icon: Icon(Icons.navigate_before),
                            ),
                            SizedBox(width: 5),
                            IconButton.filledTonal(
                              onPressed: selectedSlideOrIsAdding! < cue.requireValue.content.length - 1
                                  ? () {
                                      setState(() {
                                        selectedSlideOrIsAdding = selectedSlideOrIsAdding! + 1;
                                      });
                                    }
                                  : null,
                              icon: Icon(Icons.navigate_next),
                            ),
                            Text(slides.requireValue[selectedSlideOrIsAdding!].comment ?? ''),
                            Spacer(),
                            IconButton(
                              onPressed: () => setState(() {
                                isSlideViewExpanded = !isSlideViewExpanded;
                              }),
                              tooltip: isSlideViewExpanded ? 'Előnézet' : 'Teljes képernyő',
                              icon: Icon(isSlideViewExpanded ? Icons.fullscreen_exit : Icons.fullscreen),
                            ),
                            IconButton(
                              onPressed: () => setState(() {
                                selectedSlideOrIsAdding = null;
                              }),
                              tooltip: 'Előnézet bezárása',
                              icon: Icon(Icons.close),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                      Expanded(
                        child: switch (slides.requireValue[selectedSlideOrIsAdding!]) {
                          (SongSlide songSlide) => SongSlideView(songSlide),
                          (UnknownTypeSlide unknownSlide) => LErrorCard(
                              type: LErrorType.warning,
                              title: 'Ismeretlen diatípus. Talán újabb verzióban készítették a listát?',
                              icon: Icons.question_mark,
                              message: unknownSlide.getPreview(),
                              stack: unknownSlide.json.toString(),
                            ),
                        },
                      ),
                    ],
                  ),
                ),
              ),
            if (cue.hasValue && isSongAddingMode)
              Expanded(
                flex: 2,
                child: SongsPage(
                  addingToCue: cue.requireValue,
                ),
              )
          ],
        ),
      );
    });
  }
}

class UnknownTypeSlideTile extends StatelessWidget {
  const UnknownTypeSlideTile(this.slide,
      {required this.selectCallback, required this.removeCallback, required this.selected, super.key});

  final GestureTapCallback selectCallback;
  final GestureTapCallback removeCallback;
  final bool selected;
  final Slide slide;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Ismeretlen diatípus'),
      onTap: selectCallback,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: removeCallback, icon: Icon(Icons.delete_outline)),
          if (globals.isMobile) Icon(Icons.drag_handle),
        ],
      ),
      selected: selected,
      tileColor: Theme.of(context).colorScheme.errorContainer,
      textColor: Theme.of(context).colorScheme.onErrorContainer,
    );
  }
}

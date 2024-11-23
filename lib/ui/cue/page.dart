import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/cue/slide.dart';
import 'package:lyric/main.dart';
import 'package:lyric/services/cue/from_id.dart';
import 'package:lyric/ui/common/error.dart';
import 'package:lyric/ui/cue/slide_views/song.dart';

class CuePage extends ConsumerStatefulWidget {
  const CuePage(this.cueId, {this.initialSlideIndex, super.key});

  final int cueId;
  final int? initialSlideIndex;

  @override
  ConsumerState<CuePage> createState() => _CuePageState();
}

class _CuePageState extends ConsumerState<CuePage> {
  int? selectedSlideIndex;

  @override
  void initState() {
    selectedSlideIndex = widget.initialSlideIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cue = ref.watch(revivedCueFromIdProvider(widget.cueId));

    return LayoutBuilder(builder: (context, contraints) {
      return Flex(
        direction: contraints.maxWidth > globals.tabletFromWidth ? Axis.horizontal : Axis.vertical,
        children: [
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text(cue.value?.title ?? ''),
              ),
              body: switch (cue) {
                AsyncError(:final error, :final stackTrace) => LErrorCard(
                    type: LErrorType.error,
                    title: 'Nem sikerült betölteni a listát!',
                    icon: Icons.error,
                    message: error.toString(),
                    stack: stackTrace.toString(),
                  ),
                AsyncLoading() => Center(
                    child: CircularProgressIndicator(),
                  ),
                AsyncValue(:final value!) => ListTileTheme(
                    selectedTileColor: Theme.of(context).indicatorColor,
                    child: ListView(
                      children: value.slides!.asMap().entries.map(
                        (indexedEntry) {
                          callback() => setState(() {
                                selectedSlideIndex = indexedEntry.key;
                              });
                          switch (indexedEntry.value) {
                            case SongSlide songSlide:
                              return SongSlideTile(
                                songSlide,
                                callback,
                                selected: indexedEntry.key == selectedSlideIndex,
                              );
                            case UnknownTypeSlide unknownTypeSlide:
                              return UnknownTypeSlideTile(
                                unknownTypeSlide,
                                callback,
                                selected: indexedEntry.key == selectedSlideIndex,
                              );
                          }
                        },
                      ).toList(),
                    ),
                  )
              },
              floatingActionButton:
                  (contraints.maxWidth > globals.tabletFromWidth || selectedSlideIndex == null)
                      ? FloatingActionButton.extended(
                          onPressed: () {},
                          label: Text('Énekek hozzáadása'),
                          icon: Icon(Icons.playlist_add),
                        )
                      : FloatingActionButton.small(
                          onPressed: () {},
                          tooltip: 'Énekek hozzáadása',
                          child: Icon(Icons.playlist_add),
                        ),
            ),
          ),
          if (selectedSlideIndex != null && cue.hasValue)
            Expanded(
              flex: 2,
              child: Scaffold(
                backgroundColor: Theme.of(context).indicatorColor,
                appBar: AppBar(
                  title: Text(cue.requireValue.slides![selectedSlideIndex!].comment ?? ''),
                  elevation: 1,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      onPressed: () => setState(() {
                        selectedSlideIndex = null;
                      }),
                      icon: Icon(Icons.close),
                    ),
                  ],
                  actionsPadding: EdgeInsets.only(right: 5),
                ),
                body: switch (cue.requireValue.slides![selectedSlideIndex!]) {
                  (SongSlide songSlide) => SongSlideView(songSlide),
                  (UnknownTypeSlide unknownSlide) => LErrorCard(
                      type: LErrorType.warning,
                      title: 'Ismeretlen diatípus. Elavult az appod?',
                      icon: Icons.question_mark,
                      message: unknownSlide.getPreview(),
                      stack: unknownSlide.json.toString(),
                    ),
                },
              ),
            )
        ],
      );
    });
  }
}

class UnknownTypeSlideTile extends StatelessWidget {
  const UnknownTypeSlideTile(this.slide, this.selectCallback, {required this.selected, super.key});

  final GestureTapCallback selectCallback;
  final bool selected;
  final Slide slide;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Ismeretlen diatípus'),
      onTap: selectCallback,
      selected: selected,
      tileColor: Theme.of(context).colorScheme.errorContainer,
      textColor: Theme.of(context).colorScheme.onErrorContainer,
    );
  }
}

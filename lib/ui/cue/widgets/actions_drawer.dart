import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/data/cue/cue.dart';
import 'package:lyric/data/cue/slide.dart';
import 'package:lyric/ui/common/error/card.dart';
import 'package:lyric/ui/cue/state.dart';
import 'package:lyric/ui/song/transpose/widget.dart';
import 'package:lyric/ui/song/view_chooser.dart';

class ActionsDrawer extends ConsumerStatefulWidget {
  const ActionsDrawer(this.cue, {super.key});

  final Cue cue;

  @override
  ConsumerState<ActionsDrawer> createState() => _ActionsDrawerState();
}

class _ActionsDrawerState extends ConsumerState<ActionsDrawer> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    Slide? slide = ref.watch(currentSlideOfProvider(widget.cue));
    return FadingEdgeScrollView.fromSingleChildScrollView(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...switch (slide) {
                null => [],
                UnknownTypeSlide() => [],
                SongSlide() => [
                  if (slide.contentDifferentFlag) ...[
                    LErrorCard(
                      type: LErrorType.warning,
                      title: 'Dal megváltozott',
                      icon: Icons.edit_square,
                      message:
                          'A dal tartalma megváltozott a listához adás óta.',
                      showReportButton: false,
                    ),
                    SizedBox(height: 8),
                  ],
                  ViewChooser(
                    song: slide.song,
                    songSlide: slide,
                    useDropdown: true,
                  ),
                  SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push('/song/${slide.song.uuid}'),
                    label: Text('Ugrás a dalhoz'),
                    icon: Icon(Icons.redo),
                  ),
                  SizedBox(height: 8),
                  TransposeCard(song: slide.song, songSlide: slide),
                ],
              },
            ],
          ),
        ),
      ),
    );
  }
}

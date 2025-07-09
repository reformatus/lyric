import 'package:dart_opensong/dart_opensong.dart' as os;
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/services/preferences/providers/lyrics_view_style.dart';
import '../transpose/state.dart';
import '../../../data/cue/slide.dart';
import '../../../data/song/transpose.dart';
import '../../../services/key/get_transposed.dart';
import '../../../services/song/verse_tag_pretty.dart';
import '../../common/error/card.dart';
import 'package:chord_transposer/chord_transposer.dart';

import '../../../data/song/song.dart';

class LyricsView extends ConsumerWidget {
  LyricsView(this.song, {this.songSlide, super.key});

  final Song song;
  final SongSlide? songSlide;

  final ChordTransposer transposer = ChordTransposer(
    notation: NoteNotation.germanWithAccidentals, // TODO configurable
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SongTranspose transpose = ref.watch(
      transposeStateForProvider(song, songSlide),
    );
    final lyricsViewStyle = ref.watch(lyricsViewStylePreferencesProvider);

    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          //! Calculate layout
          int crossAxisCount =
              (constraints.maxWidth ~/ lyricsViewStyle.verseCardColumnWidth)
                  .clamp(1, 9999);
          double cardWidth = (constraints.maxWidth / crossAxisCount);

          // When scrolling sideways, make sure a bit of the next column is visible
          if (crossAxisCount > 1) cardWidth -= (30 / (crossAxisCount));

          //! Parse OpenSong
          var openSongContent = song.contentMap['opensong'];
          if (openSongContent == null) {
            return Center(
              child: LErrorCard(
                type: LErrorType.warning,
                title: 'A dalhoz nem tartozik dalszöveg!',
                icon: Icons.error,
              ),
            );
          }

          final verses = os.getVersesFromString(openSongContent);

          // far future todo Parse ChordPro

          return SingleChildScrollView(
            scrollDirection: crossAxisCount > 1
                ? Axis.horizontal
                : Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  if (transpose.capo != 0)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Capo: ${transpose.capo}',
                        style: TextStyle(fontSize: lyricsViewStyle.chordsSize),
                      ),
                    ),
                  ...verses.map(
                    (e) => SizedBox(
                      width: cardWidth,
                      child: VerseCard(song, e, transpose: transpose),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VerseCard extends ConsumerStatefulWidget {
  const VerseCard(this.song, this.verse, {required this.transpose, super.key});

  final os.Verse verse;
  final Song song;
  final SongTranspose transpose;

  @override
  ConsumerState<VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends ConsumerState<VerseCard> {
  late final ScrollController cardController;

  @override
  void initState() {
    cardController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lyricsViewStyle = ref.watch(lyricsViewStylePreferencesProvider);

    return FadingEdgeScrollView.fromSingleChildScrollView(
      child: SingleChildScrollView(
        controller: cardController,
        child: Padding(
          padding: EdgeInsets.only(top: 5, left: 5, right: 5),
          child: Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.onPrimary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.verse.tag.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      getPrettyVerseTagFrom(
                        widget.verse.type,
                        widget.verse.index,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: lyricsViewStyle.verseTagSize,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.verse.parts
                        .map(
                          (e) => switch (e) {
                            os.VerseLine(:final segments) => Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: segments
                                  .map(
                                    (e) => LyricsSegment(
                                      song: widget.song,
                                      transpose: widget.transpose,
                                      segments: segments,
                                      e: e,
                                    ),
                                  )
                                  .toList(),
                            ),
                            os.CommentLine(:final comment) => Text(
                              comment,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            os.NewSlide() => Divider(),
                            os.EmptyLine() => Text(''),
                            os.UnsupportedLine(:final original) => LErrorCard(
                              type: LErrorType.info,
                              title: 'Ismeretlen sortípus',
                              message: original,
                              icon: Icons.question_mark,
                            ),
                          },
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LyricsSegment extends ConsumerWidget {
  const LyricsSegment({
    super.key,
    required this.song,
    required this.transpose,
    required this.segments,
    required this.e,
  });

  final List<os.VerseLineSegment> segments;
  final os.VerseLineSegment e;
  final Song song;
  final SongTranspose transpose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lyricsViewStyle = ref.watch(lyricsViewStylePreferencesProvider);

    final chord = getTransposedChord(
      e.chord,
      song.keyField?.pitch,
      transpose.finalTransposeBy,
    );

    final TextPainter chordPainter = TextPainter(
      text: TextSpan(
        text: chord ?? '',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: lyricsViewStyle.chordsSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final TextPainter lyricsPainter = TextPainter(
      text: TextSpan(
        text: e.lyrics,
        style: TextStyle(fontSize: lyricsViewStyle.lyricsSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final double chordWidth = chord != null ? chordPainter.width + 4 : 0;

    double hyphenWidth = 0;

    if (e.hyphenAfter) {
      hyphenWidth = (chordWidth - lyricsPainter.width).clamp(
        0,
        double.infinity,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (segments.any((s) => s.chord != null))
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: Text(
                  chord ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: lyricsViewStyle.chordsSize,
                  ),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (e.lyrics.isNotEmpty)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: Text(
                      e.lyrics,
                      style: TextStyle(fontSize: lyricsViewStyle.lyricsSize),
                    ),
                  )
                else
                  SizedBox(height: 8),
                if (hyphenWidth > 2)
                  SizedBox(
                    width: hyphenWidth,
                    child: ClipRect(
                      child: Center(
                        child: Text(
                          "-",
                          style: TextStyle(
                            fontSize: lyricsViewStyle.lyricsSize,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

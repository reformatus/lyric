import 'package:dart_opensong/dart_opensong.dart' as os;
import 'package:flutter/material.dart';
import '../../../data/song/transpose.dart';
import '../../../services/key/get_transposed.dart';
import '../../../services/song/verse_tag_pretty.dart';
import '../../common/error/card.dart';
import 'package:chord_transposer/chord_transposer.dart';

import '../../../data/song/song.dart';

class LyricsView extends StatelessWidget {
  LyricsView(this.song, {this.transposeOptional, super.key});

  final Song song;
  final SongTranspose? transposeOptional;
  late final SongTranspose transpose;

  final ChordTransposer transposer = ChordTransposer(
    notation: NoteNotation.germanWithAccidentals, // TODO configurable
  );

  @override
  Widget build(BuildContext context) {
    if (transposeOptional == null) {
      transpose = SongTranspose();
    } else {
      transpose = transposeOptional!;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        //! Calculate layout
        int crossAxisCount = (constraints.maxWidth ~/ 350).clamp(1, 9999);
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
        var verses = os.getVersesFromString(openSongContent);

        // far future todo Parse ChordPro

        return SingleChildScrollView(
          scrollDirection: crossAxisCount > 1 ? Axis.horizontal : Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Wrap(
              direction: Axis.vertical,
              children: [
                if (transpose.capo != 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Capo: ${transpose.capo}'),
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
    );
  }
}

class VerseCard extends StatelessWidget {
  const VerseCard(this.song, this.verse, {required this.transpose, super.key});

  final os.Verse verse;
  final Song song;
  final SongTranspose transpose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
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
                getPrettyVerseTagFrom(verse.type, verse.index),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    verse.parts
                        .map(
                          (e) => switch (e) {
                            os.VerseLine(:final segments) => Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children:
                                  segments
                                      .map(
                                        (e) => LyricsSegment(
                                          song: song,
                                          transpose: transpose,
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
                              type: LErrorType.warning,
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
    );
  }
}

class LyricsSegment extends StatelessWidget {
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

  // TODO transpose whole song at once, avoid watching transpose at all segments duh...
  @override
  Widget build(BuildContext context) {
    final chord = getTransposedChord(
      e.chord,
      song.keyField?.pitch,
      transpose.finalTransposeBy,
    );

    final TextPainter chordPainter = TextPainter(
      text: TextSpan(
        text: chord ?? '',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final TextPainter lyricsPainter = TextPainter(
      text: TextSpan(text: e.lyrics),
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
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (e.lyrics.isNotEmpty)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: Text(e.lyrics),
                  )
                else
                  SizedBox(height: 8),
                if (hyphenWidth > 2)
                  SizedBox(
                    width: hyphenWidth,
                    child: ClipRect(child: Center(child: Text("-"))),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

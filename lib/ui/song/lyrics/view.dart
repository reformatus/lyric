import 'package:dart_opensong/dart_opensong.dart' as os;
import 'package:flutter/material.dart';
import 'package:lyric/services/song/verse_tag_pretty.dart';
import 'package:lyric/ui/common/error.dart';

import '../../../data/song/song.dart';

class LyricsView extends StatelessWidget {
  const LyricsView(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    var openSongContent = song.contentMap['opensong'];
    if (openSongContent == null)
      return Center(child: Text('Ehhez az énekhez nincs dalszöveg :('));

    var verses = os.getVersesFromString(openSongContent);
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = (constraints.maxWidth ~/ 400).clamp(1, 9999);
        double cardWidth = (constraints.maxWidth / crossAxisCount);

        // When scrolling sideways, make sure a bit of the next column is visible
        if (crossAxisCount > 1) cardWidth -= (30 / (crossAxisCount));

        return SingleChildScrollView(
          scrollDirection: crossAxisCount > 1 ? Axis.horizontal : Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Wrap(
              direction: Axis.vertical,
              children:
                  verses
                      .map(
                        (e) => SizedBox(width: cardWidth, child: VerseCard(e)),
                      )
                      .toList(),
            ),
          ),
        );
      },
    );
  }
}

class VerseCard extends StatelessWidget {
  const VerseCard(this.verse, {super.key});

  final os.Verse verse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Card(
        elevation: 0,
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
                                        (e) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (segments.any(
                                              (s) => s.chord != null,
                                            ))
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  right: 3,
                                                ),
                                                child: Text(
                                                  e.chord ?? '',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            if (e.lyrics.isNotEmpty)
                                              Text(e.lyrics)
                                            else
                                              SizedBox(height: 10),
                                          ],
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

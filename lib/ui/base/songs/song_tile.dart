import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/services/cue/slide/song_slide.dart';
import 'package:lyric/services/songs/filter.dart';
import 'package:lyric/ui/common/error.dart';

import '../../../data/cue/cue.dart';
import '../../../data/database.dart';

class LSongResultTile extends StatelessWidget {
  const LSongResultTile(this.songResult, {this.addingToCue, super.key});

  final SongResult songResult;
  final Cue? addingToCue;

  @override
  Widget build(BuildContext context) {
    final SongsFt? songsFt = songResult.songsFt;
    final SongFulltextSearchResult? match = songResult.match;

    if (songsFt != null) {
      String firstLine = "";
      try {
        firstLine = jsonDecode(songsFt.contentMap)['first_line'] ??
            songsFt.lyrics.substring(songsFt.lyrics.indexOf('\n'));
      } catch (_) {
        firstLine = songsFt.lyrics;
      }
      return ListTile(
        // far future todo dense on desktop (maybe even table?)
        onTap: addingToCue == null ? () => context.push('/song/${songsFt.uuid}') : null,
        title: Text(songsFt.title),
        trailing: Text(songsFt.keyField.toString()),
        leading: addingToCue != null
            ? IconButton.filledTonal(
                onPressed: () => addSongSlideToCueForSongWithUuid(cue: addingToCue!, songUuid: songsFt.uuid),
                icon: Icon(Icons.add))
            : null,
        subtitle: !firstLine.startsWith(songsFt.title)
            ? Text(
                firstLine,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              )
            : null,
      );
    } else if (match != null) {
      return ListTile(
        onTap: addingToCue == null ? () => context.push('/song/${match.uuid}') : null,
        leading: addingToCue != null
            ? IconButton.filledTonal(
                onPressed: () => addSongSlideToCueForSongWithUuid(cue: addingToCue!, songUuid: match.uuid),
                icon: Icon(Icons.add))
            : null,
        title: RichText(
          text: TextSpan(
            children: spansFromSnippet(
              match.matchTitle,
              normalStyle: Theme.of(context).textTheme.bodyLarge!,
              highlightStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
        subtitle: hasMatch(match.matchLyrics) ? trailingPart(match.matchLyrics, context) : null,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasMatch(match.matchComposer)) trailingPart(match.matchComposer, context),
            if (hasMatch(match.matchLyricist)) trailingPart(match.matchLyricist, context),
            if (hasMatch(match.matchTranslator)) trailingPart(match.matchTranslator, context),
          ],
        ),
      );
    } else {
      return LErrorCard(
        type: LErrorType.warning,
        title: 'Itt egy dalnak kéne lennie',
        message: "Se a 'match', se a 'songsFt' nem volt kitöltve",
        stack: 'ui/base/songs/song_tile:70',
        icon: Icons.music_note,
      );
    }
  }

  RichText trailingPart(String matchString, BuildContext context) {
    return RichText(
      text: TextSpan(
        children: spansFromSnippet(
          matchString,
          normalStyle: Theme.of(context).textTheme.bodySmall!,
          highlightStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }
}

bool hasMatch(String snippet) {
  return snippet.contains(snippetTags.start) && snippet.contains(snippetTags.end);
}

List<TextSpan> spansFromSnippet(
  String snippet, {
  required TextStyle normalStyle,
  required TextStyle highlightStyle,
}) {
  List<TextSpan> spans = [];
  String remainingText = snippet.replaceAll('\n', ' ');
  while (remainingText.contains(snippetTags.start) && remainingText.contains(snippetTags.end)) {
    // Get the text before the match
    final int startIndex = remainingText.indexOf(snippetTags.start);
    if (startIndex > 0) {
      spans.add(TextSpan(text: remainingText.substring(0, startIndex), style: normalStyle));
    }

    // Get the highlighted match
    remainingText = remainingText.substring(startIndex + snippetTags.start.length);
    final int endIndex = remainingText.indexOf(snippetTags.end);
    spans.add(TextSpan(text: remainingText.substring(0, endIndex), style: highlightStyle));

    // Update the remaining text after the match
    remainingText = remainingText.substring(endIndex + snippetTags.end.length);
  }

  // Add any remaining text that isn't highlighted
  if (remainingText.isNotEmpty) {
    spans.add(TextSpan(text: remainingText, style: normalStyle));
  }

  return spans;
}

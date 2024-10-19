import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/services/songs/filter.dart';

import '../../../data/database.dart';
import '../../../data/song/song.dart';

class LSongResultTile extends StatelessWidget {
  const LSongResultTile(this.songResult, {super.key});

  final SongResult songResult;

  @override
  Widget build(BuildContext context) {
    final Song song = songResult.song;
    final SongFulltextSearchResult? match = songResult.match;

    if (match == null) {
      final firstLine = song.content['first_line'] ?? song.lyrics.substring(song.lyrics.indexOf('\n'));
      return ListTile(
        onTap: () => context.push('/song/${song.uuid}'),
        title: Text(song.title),
        trailing: Text(song.pitchField?.toString() ?? ''),
        subtitle: !firstLine.startsWith(song.title)
            ? Text(
                firstLine,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              )
            : null,
      );
    } else {
      return ListTile(
        onTap: () => context.push('/song/${song.uuid}'),
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
            if (hasMatch(match.matchPoet)) trailingPart(match.matchPoet, context),
            if (hasMatch(match.matchTranslator)) trailingPart(match.matchTranslator, context),
          ],
        ),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/song/extensions.dart';

import '../../../data/database.dart';
import '../../../data/song/song.dart';
import '../../../services/songs/filter.dart';

class LSongResultTile extends StatelessWidget {
  const LSongResultTile(this.songResult, {super.key});

  final SongResult songResult;

  @override
  Widget build(BuildContext context) {
    final Song song = songResult.song;
    final SongFulltextSearchResult? result = songResult.result;

    String firstLine = "";
    try {
      firstLine = song.contentMap['first_line'] ?? "";
      if (firstLine.isEmpty) {
        song.opensong.substring(song.opensong.indexOf('\n'));
      }
    } catch (_) {
      firstLine = song.opensong;
    }
    return ListTile(
      // far future todo dense on desktop (maybe even table?)
      onTap: () => context.push('/song/${song.uuid}'),
      title: RichText(
        text: TextSpan(
          children: spansFromSnippet(
            result?.matchTitle ?? song.title,
            normalStyle: Theme.of(context).textTheme.bodyLarge!,
            highlightStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      subtitle:
          result == null
              ? firstLine.startsWith(song.title) || firstLine.isEmpty
                  ? null
                  : Text(
                    firstLine,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasMatch(result.matchOpensong))
                    contentResultRow(
                      context,
                      Icons.text_snippet,
                      result.matchOpensong,
                    ),
                  if (hasMatch(result.matchComposer))
                    contentResultRow(
                      context,
                      Icons.music_note,
                      result.matchComposer,
                    ),
                  if (hasMatch(result.matchLyricist))
                    contentResultRow(context, Icons.edit, result.matchLyricist),
                  if (hasMatch(result.matchTranslator))
                    contentResultRow(
                      context,
                      Icons.translate,
                      result.matchTranslator,
                    ),
                ],
              ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(song.keyField.toString()),
          SizedBox(width: 10),
          SongFeatures(song),
        ],
      ),
    );
  }

  Row contentResultRow(
    BuildContext context,
    IconData iconData,
    String? matchString,
  ) {
    return Row(
      children: [
        Icon(iconData, size: 18),
        SizedBox(width: 5),
        RichText(
          text: TextSpan(
            children: spansFromSnippet(
              matchString ?? "",
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
        ),
      ],
    );
  }
}

class SongFeatures extends StatelessWidget {
  const SongFeatures(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Wrap(
        children: [
          indicatorIcon(context, Icons.music_note_outlined, song.hasSvg),
          indicatorIcon(context, Icons.audio_file_outlined, song.hasPdf),
          indicatorIcon(context, Icons.text_snippet_outlined, song.hasLyrics),
          indicatorIcon(context, Icons.tag_outlined, song.hasChords),
        ],
      ),
    );
  }

  Widget indicatorIcon(BuildContext context, IconData iconData, bool active) {
    return Icon(
      iconData,
      color: active ? null : Theme.of(context).disabledColor,
      size: 18,
    );
  }
}

bool hasMatch(String? snippet) {
  if (snippet == null) return false;
  return snippet.contains(snippetTags.start) &&
      snippet.contains(snippetTags.end);
}

List<TextSpan> spansFromSnippet(
  String? snippet, {
  required TextStyle normalStyle,
  required TextStyle highlightStyle,
}) {
  List<TextSpan> spans = [];
  String remainingText = (snippet ?? "").replaceAll('\n', ' ');
  while (remainingText.contains(snippetTags.start) &&
      remainingText.contains(snippetTags.end)) {
    // Get the text before the match
    final int startIndex = remainingText.indexOf(snippetTags.start);
    if (startIndex > 0) {
      spans.add(
        TextSpan(
          text: remainingText.substring(0, startIndex),
          style: normalStyle,
        ),
      );
    }

    // Get the highlighted match
    remainingText = remainingText.substring(
      startIndex + snippetTags.start.length,
    );
    final int endIndex = remainingText.indexOf(snippetTags.end);
    spans.add(
      TextSpan(
        text: remainingText.substring(0, endIndex),
        style: highlightStyle,
      ),
    );

    // Update the remaining text after the match
    remainingText = remainingText.substring(endIndex + snippetTags.end.length);
  }

  // Add any remaining text that isn't highlighted
  if (remainingText.isNotEmpty) {
    spans.add(TextSpan(text: remainingText, style: normalStyle));
  }

  return spans;
}

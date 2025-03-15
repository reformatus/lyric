import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/cue/cue.dart';
import '../../../data/database.dart';
import '../../../data/song/song.dart';
import '../../../services/cue/slide/song_slide.dart';
import '../../../services/songs/filter.dart';

class LSongResultTile extends StatelessWidget {
  const LSongResultTile(this.songResult, {this.addingToCue, super.key});

  final SongResult songResult;
  final Cue? addingToCue;

  @override
  Widget build(BuildContext context) {
    final Song song = songResult.song;
    final SongFulltextSearchResult? result = songResult.result;

    if (result == null) {
      String firstLine = "";
      try {
        firstLine =
            song.contentMap['first_line'] ??
            song.opensong.substring(song.opensong.indexOf('\n'));
      } catch (_) {
        firstLine = song.opensong;
      }
      return ListTile(
        // far future todo dense on desktop (maybe even table?)
        onTap:
            addingToCue == null
                ? () => context.push('/song/${song.uuid}')
                : null,
        title: Text(song.title),
        leading:
            addingToCue != null
                ? IconButton.filledTonal(
                  onPressed:
                      () => addSongSlideToCueForSongWithUuid(
                        cue: addingToCue!,
                        songUuid: song.uuid,
                      ),
                  icon: Icon(Icons.add),
                )
                : null,
        subtitle:
            !firstLine.startsWith(song.title)
                ? Text(
                  firstLine,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                )
                : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(song.keyField.toString()),
            SizedBox(width: 5),
            SizedBox(
              width: 40,
              child: Wrap(
                children: [
                  // TODO implement
                  Icon(
                    Icons.music_note_outlined,
                    color: Theme.of(context).disabledColor,
                    size: 20,
                  ),
                  Icon(
                    Icons.audio_file_outlined,
                    color: Theme.of(context).disabledColor,
                    size: 20,
                  ),
                  Icon(
                    Icons.text_snippet_outlined,
                    color: Theme.of(context).disabledColor,
                    size: 20,
                  ),
                  Icon(
                    Icons.tag_outlined,
                    color: Theme.of(context).disabledColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return ListTile(
        onTap:
            addingToCue == null
                ? () => context.push('/song/${song.uuid}')
                : null,
        leading:
            addingToCue != null
                ? IconButton.filledTonal(
                  onPressed:
                      () => addSongSlideToCueForSongWithUuid(
                        cue: addingToCue!,
                        songUuid: song.uuid,
                      ),
                  icon: Icon(Icons.add),
                )
                : null,
        title: RichText(
          text: TextSpan(
            children: spansFromSnippet(
              result.matchTitle,
              normalStyle: Theme.of(context).textTheme.bodyLarge!,
              highlightStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        subtitle:
            hasMatch(result.matchOpensong)
                ? trailingPart(result.matchOpensong, context)
                : null,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasMatch(result.matchComposer))
              trailingPart(result.matchComposer, context),
            if (hasMatch(result.matchLyricist))
              trailingPart(result.matchLyricist, context),
            if (hasMatch(result.matchTranslator))
              trailingPart(result.matchTranslator, context),
          ],
        ),
      );
    }
  }

  RichText trailingPart(String? matchString, BuildContext context) {
    return RichText(
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/bank/bank.dart';
import '../../../../data/song/extensions.dart';

import '../../../../data/database.dart';
import '../../../../data/song/song.dart';
import '../../../../services/songs/filter.dart';

class LSongResultTile extends StatelessWidget {
  const LSongResultTile(this.songResult, this.bank, {super.key});

  final SongResult songResult;
  final Bank bank;

  @override
  Widget build(BuildContext context) {
    final Song song = songResult.song;
    final SongFulltextSearchResult? result = songResult.result;
    final List<String> downloadedAssets = songResult.downloadedAssets;

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
      subtitle: result == null
          ? song.firstLine.startsWith(song.title) || song.firstLine.isEmpty
                ? null
                : Text(
                    song.firstLine,
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
      leading: bank.tinyLogo != null
          ? Tooltip(
              message: bank.name,
              child: Padding(
                padding: EdgeInsetsGeometry.only(right: 5),
                child: Image.memory(
                  bank.tinyLogo!,
                  cacheHeight: 26,
                  cacheWidth: 26,
                ),
              ),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(song.keyField?.toString() ?? ''),
          SizedBox(width: 10),
          if (downloadedAssets.isNotEmpty) ...[
            Tooltip(
              message: 'Kottakép letöltve',
              child: Icon(Icons.offline_pin, color: Colors.green[600]),
            ),
            SizedBox(width: 10),
          ],
          SongFeatures(song, downloadedAssets),
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
  const SongFeatures(this.song, this.downloadedAssets, {super.key});

  final Song song;
  final List<String> downloadedAssets;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      richMessage: TextSpan(
        children: [
          // TODO factor out to make configurable
          TextSpan(text: 'Tartalom: '),
          WidgetSpan(
            child: Icon(
              Icons.music_note_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          TextSpan(text: 'Kotta, '),
          WidgetSpan(
            child: Icon(
              Icons.audio_file_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          TextSpan(text: 'PDF, '),
          WidgetSpan(
            child: Icon(
              Icons.text_snippet_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          TextSpan(text: 'Dalszöveg, '),
          WidgetSpan(
            child: Icon(
              Icons.tag_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          TextSpan(text: 'Akkord'),
          TextSpan(text: '\nZöld: letöltve, Szürke: nem elérhető'),
        ],
      ),
      child: Wrap(
        direction: Axis.vertical,
        // TODO factor out to make configurable
        children: [
          indicatorIcon(
            context,
            Icons.music_note_outlined,
            available: song.hasSvg,
            downloaded: downloadedAssets.contains('svg'),
          ),
          indicatorIcon(
            context,
            Icons.audio_file_outlined,
            available: song.hasPdf,
            downloaded: downloadedAssets.contains('pdf'),
          ),
          indicatorIcon(
            context,
            Icons.text_snippet_outlined,
            available: song.hasLyrics,
            downloaded: song.hasLyrics,
          ),
          indicatorIcon(
            context,
            Icons.tag_outlined,
            available: song.hasChords,
            downloaded: song.hasChords,
          ),
        ],
      ),
    );
  }

  Widget indicatorIcon(
    BuildContext context,
    IconData iconData, {
    required bool available,
    bool downloaded = false,
  }) {
    Color? color;
    if (downloaded) {
      color = Colors.green[600];
    } else if (available) {
      color = null;
    } else {
      color = Theme.of(context).disabledColor.withAlpha(60);
    }

    return Icon(iconData, color: color, size: 18);
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

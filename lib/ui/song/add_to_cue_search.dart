import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/cue/cue.dart';
import 'package:lyric/data/song/song.dart';
import 'package:lyric/data/song/transpose.dart';
import 'package:lyric/services/cue/cues.dart';
import 'package:lyric/services/cue/slide/song_slide.dart';
import 'package:lyric/ui/common/error/card.dart';
import 'package:lyric/ui/song/state.dart';

/// A reusable widget that provides search functionality for adding songs to cues
class AddToCueSearch extends ConsumerStatefulWidget {
  const AddToCueSearch({
    required this.song,
    required this.isDesktop,
    required this.viewType,
    required this.transpose,
    super.key,
  });

  final Song song;
  final bool isDesktop;
  final SongViewType viewType;
  final SongTranspose transpose;

  @override
  ConsumerState<AddToCueSearch> createState() => _AddToCueSearchState();
}

class _AddToCueSearchState extends ConsumerState<AddToCueSearch> {
  @override
  void initState() {
    searchController = SearchController();
    super.initState();
  }

  late final SearchController searchController;
  @override
  Widget build(BuildContext context) {
    Future<void> handleCueSelection(
      SearchController controller,
      Cue cue,
    ) async {
      addSongSlideToCueForSong(
        cue: cue,
        song: widget.song,
        viewType: widget.viewType,
        transpose: widget.transpose,
      );
      controller.closeView('');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.song.title} hozzáadva a listához: ${cue.title}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    Future<List<Cue>> filterCues(String searchText) async {
      final cues = await ref.read(watchAllCuesProvider.future);
      return cues
          .where(
            (cue) =>
                cue.title.toLowerCase().contains(searchText.toLowerCase()) ||
                cue.description.toLowerCase().contains(
                  searchText.toLowerCase(),
                ),
          )
          .toList();
    }

    return SearchAnchor(
      searchController: searchController,
      viewOnSubmitted: (value) async {
        if (value.isEmpty) return;

        final filteredCues = await filterCues(value);
        if (filteredCues.isNotEmpty) {
          await handleCueSelection(searchController, filteredCues.first);
        }
      },
      builder: (context, controller) {
        if (!widget.isDesktop) {
          return FilledButton.tonalIcon(
            icon: Icon(Icons.playlist_add),
            label: Text('Listához adás'),
            onPressed: () => controller.openView(),
          );
        } else {
          return SearchBar(
            controller: controller,
            leading: Icon(Icons.playlist_add),
            hintText: 'Listához adás...',
            elevation: WidgetStatePropertyAll(1),
            onTap: () => controller.openView(),
            onChanged: (_) => controller.openView(),
          );
        }
      },
      suggestionsBuilder: (context, controller) async {
        try {
          final filteredCues = await filterCues(controller.text);

          return filteredCues.asMap().entries.map((cueEntry) {
            final selected = cueEntry.key == 0 && controller.text.isNotEmpty;
            return ListTile(
              selected: selected,
              selectedTileColor: Theme.of(context).cardColor,
              title: Text(cueEntry.value.title),
              subtitle:
                  cueEntry.value.description.isNotEmpty
                      ? Text(
                        cueEntry.value.description.split('\n').first,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      )
                      : null,
              trailing: selected ? Icon(Icons.keyboard_return) : null,
              onTap: () => handleCueSelection(controller, cueEntry.value),
            );
          }).toList();
        } catch (e, s) {
          return [
            LErrorCard(
              type: LErrorType.error,
              title: 'Nem sikerült betölteni a listákat :(',
              message: e.toString(),
              stack: s.toString(),
              icon: Icons.list,
            ),
          ];
        }
      },
    );
  }
}

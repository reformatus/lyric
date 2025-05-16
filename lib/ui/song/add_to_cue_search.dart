import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/cue/cue.dart';
import '../../data/song/song.dart';
import '../../data/song/transpose.dart';
import '../../services/cue/cues.dart';
import '../../services/cue/slide/song_slide.dart';
import '../base/cues/dialogs.dart';
import '../common/error/card.dart';
import 'state.dart';

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
      String slideUuid = await addNewSlideOfSongToCue(
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
          action: SnackBarAction(
            label: 'Ugrás',
            onPressed: () => context.push('/cue/${cue.uuid}?slide=$slideUuid'),
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

          if (!mounted) return [];

          return [
                if (controller.text.isEmpty || filteredCues.isEmpty)
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text(
                      [
                        'Hozzáadás új listához',
                        if (filteredCues.isEmpty &&
                            controller.text.isNotEmpty) ...[
                          ': ',
                          controller.text,
                        ],
                      ].join(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize:
                            // ignore: use_build_context_synchronously
                            Theme.of(context).textTheme.bodyMedium?.fontSize,
                      ),
                    ),
                    onTap:
                        () => showAdaptiveDialog(
                          context: context,
                          builder:
                              (context) => EditCueDialog(
                                prefilledTitle: controller.text,
                              ),
                        ).then((createdCue) {
                          if (createdCue == null) return;
                          createdCue as Cue;
                          handleCueSelection(controller, createdCue);
                        }),
                  ),
              ]
              .followedBy(
                filteredCues.asMap().entries.map((cueEntry) {
                  final selected =
                      cueEntry.key == 0 && controller.text.isNotEmpty;
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
                }),
              )
              .toList();
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

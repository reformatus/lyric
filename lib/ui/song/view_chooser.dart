import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/song/extensions.dart';
import 'package:lyric/data/song/song.dart';
import 'package:lyric/ui/song/state.dart';

class ViewChooser extends ConsumerWidget {
  const ViewChooser({
    super.key,
    required this.viewType,
    required this.song,
    required this.listId,
    required this.useDropdown,
  });

  final SongViewType viewType;
  final Song song;
  final String? listId;
  final bool useDropdown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<
      ({SongViewType value, IconData icon, String label, bool enabled})
    >
    viewTypeEntries = [
      (
        value: SongViewType.svg,
        icon: Icons.music_note_outlined,
        label: 'Kotta',
        enabled: song.hasSvg,
      ),
      (
        value: SongViewType.pdf,
        icon: Icons.audio_file_outlined,
        label: 'PDF',
        enabled: song.hasPdf,
      ),
      (
        value: SongViewType.lyrics,
        icon: song.hasChords ? Icons.tag_outlined : Icons.text_snippet_outlined,
        label: song.hasChords ? 'Akkordok' : 'Dalszöveg',
        enabled: song.hasLyrics,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!useDropdown) {
          return SegmentedButton<SongViewType>(
            selected: {viewType},
            onSelectionChanged: (viewTypeSet) {
              ref
                  .read(ViewTypeForProvider(song.uuid, listId).notifier)
                  .changeTo(viewTypeSet.first);
            },
            showSelectedIcon: false,
            multiSelectionEnabled: false,
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ),
            segments:
                viewTypeEntries
                    .map(
                      (e) => ButtonSegment(
                        value: e.value,
                        label: Text(e.label),
                        icon: Icon(e.icon),
                        enabled: e.enabled,
                        tooltip: !e.enabled ? 'Nem elérhető' : null,
                      ),
                    )
                    .toList(),
          );
        } else {
          return DropdownButtonHideUnderline(
            child: DropdownButton<SongViewType>(
              value: viewType,
              onChanged:
                  (viewType) => ref
                      .read(ViewTypeForProvider(song.uuid, listId).notifier)
                      .changeTo(viewType!),
              items:
                  viewTypeEntries
                      .where((e) => e.enabled)
                      .map(
                        (e) => DropdownMenuItem(
                          enabled: e.enabled,
                          value: e.value,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(e.icon),
                              ),
                              Text(e.label),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          );
        }
      },
    );
  }
}

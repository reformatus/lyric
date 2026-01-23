import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/cue/slide.dart';
import '../../data/song/extensions.dart';
import '../../data/song/song.dart';
import 'state.dart';

class ViewChooser extends ConsumerWidget {
  const ViewChooser({
    super.key,
    required this.song,
    this.songSlide,
    required this.useDropdown,
  });

  final Song song;
  final bool useDropdown;
  final SongSlide? songSlide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<({SongViewType value, IconData icon, String label, bool enabled})>
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
      if (song.hasChords)
        (
          value: SongViewType.chords,
          icon: Icons.tag_outlined,
          label: 'Akkordok',
          enabled: song.hasChords,
        )
      else
        (
          value: SongViewType.lyrics,
          icon: Icons.text_snippet_outlined,
          label: 'Dalszöveg',
          enabled: song.hasLyrics,
        ),
    ];

    final viewTypeAsync = ref.watch(viewTypeForProvider(song, songSlide));

    if (!viewTypeAsync.hasValue) return const SizedBox.shrink();
    final viewType = viewTypeAsync.requireValue;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!useDropdown) {
          return SegmentedButton<SongViewType>(
            selected: {viewType},
            onSelectionChanged: (viewTypeSet) {
              final newViewType = viewTypeSet.first;
              ref
                  .read(viewTypeForProvider(song, songSlide).notifier)
                  .setTo(newViewType);
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
            segments: viewTypeEntries
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
          return FilledButton(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              enableFeedback: false,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
            ),
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () {},
            child: DropdownButton<SongViewType>(
              borderRadius: BorderRadius.circular(15),
              isDense: true,
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 5),
              underline: SizedBox.shrink(),
              focusColor: Colors.transparent,
              icon: Icon(
                Icons.arrow_drop_down_rounded,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
              autofocus: false,
              value: viewType,
              onChanged: (newViewType) {
                if (newViewType == null) return;
                ref
                    .read(viewTypeForProvider(song, songSlide).notifier)
                    .setTo(newViewType);
              },
              items: viewTypeEntries
                  .where((e) => e.enabled)
                  .map(
                    (e) => DropdownMenuItem(
                      enabled: e.enabled,
                      value: e.value,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              e.icon,
                              color: Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
                          Text(
                            e.label,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/song/song.dart';
import '../add_to_cue_search.dart';
import '../state.dart';
import '../transpose/state.dart';
import '../transpose/widget.dart';

class DesktopSidebar extends ConsumerWidget {
  const DesktopSidebar({
    super.key,
    required this.song,
    required this.constraints,
    required this.detailsContent,
  });

  final Song song;
  final BoxConstraints constraints;
  final List<Widget> detailsContent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewTypeAsync = ref.watch(ViewTypeForProvider(song, null));
    final transpose = ref.watch(transposeStateForProvider(song, null));

    if (!viewTypeAsync.hasValue) return SizedBox.shrink();

    final viewType = viewTypeAsync.requireValue;

    return SizedBox(
      width: (constraints.maxWidth / 5).clamp(200, 350),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (viewType == SongViewType.chords) ...[
                TransposeCard(song: song),
                SizedBox(height: 10),
              ],
              AddToCueSearch(
                song: song,
                isDesktop: true,
                viewType: viewType,
                transpose: transpose,
              ),
              SizedBox(height: 10),
              const Divider(),
              ...detailsContent,
            ],
          ),
        ),
      ),
    );
  }
}

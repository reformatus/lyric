import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

import '../../data/song/song.dart';
import '../../services/song/from_uuid.dart';
import '../common/error/card.dart';
import 'widgets/content.dart';

// TODO refactor into adaptive_page

class SongPage extends ConsumerStatefulWidget {
  const SongPage(this.songId, {super.key});
  final String songId;

  @override
  ConsumerState<SongPage> createState() => _SongPageState();
}

class _SongPageState extends ConsumerState<SongPage> {
  @override
  void initState() {
    detailsSheetScrollController = ScrollController();
    actionButtonsScrollController = ScrollController();
    transposeOverlayVisible = ValueNotifier<bool>(false);

    super.initState();
  }

  late final ScrollController detailsSheetScrollController;
  late final ScrollController actionButtonsScrollController;
  late final ValueNotifier<bool> transposeOverlayVisible;

  @override
  void dispose() {
    transposeOverlayVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = ref.watch(songFromUuidProvider(widget.songId));

    return switch (song) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error, :final stackTrace) => _buildErrorCard(
        error: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
      AsyncValue(value: null) => _buildNotFoundCard(),
      AsyncValue(value: final Song song) => SongPageContent(
        song: song,
        detailsSheetScrollController: detailsSheetScrollController,
        actionButtonsScrollController: actionButtonsScrollController,
        transposeOverlayVisible: transposeOverlayVisible,
        onShowDetailsSheet: showDetailsBottomSheet,
      ),
    };
  }

  Widget _buildErrorCard({required String error, required String stackTrace}) {
    return Center(
      child: LErrorCard(
        type: LErrorType.error,
        title: 'Nem sikerült betölteni a dalt :(',
        message: error,
        stack: stackTrace,
        icon: Icons.music_note,
      ),
    );
  }

  Widget _buildNotFoundCard() {
    return const Center(
      child: LErrorCard(
        type: LErrorType.info,
        title: 'Úgy tűnik, ez a dal nincs a táradban...',
        icon: Icons.search_off,
      ),
    );
  }

  Future<dynamic> showDetailsBottomSheet(
    BuildContext context,
    ScrollController detailsSheetScrollController,
    List<Widget> detailsContent,
  ) {
    return showSlidingBottomSheet(
      context,
      builder:
          (context) => SlidingSheetDialog(
            avoidStatusBar: true,
            maxWidth: 600,
            cornerRadius: 20,
            dismissOnBackdropTap: true,
            duration: Durations.medium2,
            headerBuilder:
                (context, state) => Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8, top: 8),
                  child: Row(
                    children: [
                      Text(
                        'Részletek',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
            builder: (context, state) {
              return Column(children: detailsContent);
            },
          ),
      useRootNavigator: false,
    );
  }
}

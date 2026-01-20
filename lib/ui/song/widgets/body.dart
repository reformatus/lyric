import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/song/song.dart';
import '../../common/error/card.dart';
import '../lyrics/view.dart';
import '../sheet/view.dart';
import '../state.dart';
import '../transpose/widget.dart';
import 'desktop_sidebar.dart';
import 'details_button.dart';
import 'mobile_bottom_bar.dart';

class SongPageBody extends ConsumerWidget {
  const SongPageBody({
    super.key,
    required this.song,
    required this.isDesktop,
    required this.isMobile,
    required this.constraints,
    required this.summaryContent,
    required this.detailsContent,
    required this.actionButtonsScrollController,
    required this.transposeOverlayVisible,
    required this.onShowDetailsSheet,
    required this.detailsSheetScrollController,
  });

  final Song song;
  final bool isDesktop;
  final bool isMobile;
  final BoxConstraints constraints;
  final List<Widget> summaryContent;
  final List<Widget> detailsContent;
  final ScrollController actionButtonsScrollController;
  final ValueNotifier<bool> transposeOverlayVisible;
  final Function(BuildContext, ScrollController, List<Widget>)
  onShowDetailsSheet;
  final ScrollController detailsSheetScrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewTypeAsync = ref.watch(viewTypeForProvider(song, null));
    if (!viewTypeAsync.hasValue) return SizedBox.shrink();
    if (viewTypeAsync.hasError) {
      return Center(
        child: LErrorCard(
          type: LErrorType.error,
          title: 'Nincs érvényes dalnézet!',
          icon: Icons.error,
          message: viewTypeAsync.error?.toString(),
          stack: viewTypeAsync.stackTrace?.toString(),
        ),
      );
    }

    final viewType = viewTypeAsync.requireValue;

    if (isDesktop) {
      return Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 4, child: _buildMainContent(viewType)),
          DesktopSidebar(
            song: song,
            constraints: constraints,
            detailsContent: detailsContent,
          ),
        ],
      );
    }

    // For mobile/tablet, use Stack to position transpose overlay
    return Stack(
      children: [
        Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 4, child: _buildMainContent(viewType)),
            if (isMobile)
              DetailsButton(
                summaryContent: summaryContent,
                detailsContent: detailsContent,
                onShowDetailsSheet: onShowDetailsSheet,
                detailsSheetScrollController: detailsSheetScrollController,
              ),
            MobileBottomBar(
              song: song,
              constraints: constraints,
              actionButtonsScrollController: actionButtonsScrollController,
              transposeOverlayVisible: transposeOverlayVisible,
            ),
          ],
        ),
        // Fixed position transpose overlay with reactive visibility
        ValueListenableBuilder<bool>(
          valueListenable: transposeOverlayVisible,
          builder: (context, isVisible, child) {
            if (viewType == SongViewType.chords && isVisible) {
              return Positioned(
                bottom: 60, // Above the bottom bar
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: TransposeControls(song, songSlide: null),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildMainContent(SongViewType viewType) {
    return switch (viewType) {
      SongViewType.svg => SheetView.svg(song),
      SongViewType.pdf => SheetView.pdf(song),
      SongViewType.lyrics || SongViewType.chords => LyricsView(song),
    };
  }
}

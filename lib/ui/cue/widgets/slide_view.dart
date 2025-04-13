import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/cue/slide.dart';
import '../../../main.dart';
import '../slide_views/song.dart';
import '../slide_views/unknown.dart';
import '../state.dart';

/// A widget that displays the content of a slide with navigation controls
class SlideView extends ConsumerWidget {
  const SlideView({
    required this.slide,
    required this.cueUuid,
    required this.currentIndex,
    required this.totalSlides,
    this.onTap,
    super.key,
  });

  final Slide slide;
  final String cueUuid;
  final int currentIndex;
  final int totalSlides;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Navigation methods from state
    final hasPrevious = currentIndex > 0;
    final hasNext = currentIndex < totalSlides - 1;

    return Column(
      children: [
        // Control bar
        _buildControlBar(context, ref, hasPrevious, hasNext),

        // Main slide content
        Expanded(child: _buildSlideContent(context, ref)),
      ],
    );
  }

  Widget _buildControlBar(
    BuildContext context,
    WidgetRef ref,
    bool hasPrevious,
    bool hasNext,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed:
                hasPrevious
                    ? () =>
                        ref.read(currentSlideProvider.notifier).changeSlide(-1)
                    : null,
            icon: const Icon(Icons.navigate_before),
            tooltip: 'Előző dia',
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed:
                hasNext
                    ? () =>
                        ref.read(currentSlideProvider.notifier).changeSlide(1)
                    : null,
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Következő dia',
          ),
          const SizedBox(width: 16),
          Text(
            '${currentIndex + 1}. / $totalSlides dia',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          // Only show fullscreen button on desktop platforms
          if (globals.isDesktop)
            IconButton(
              onPressed: onTap,
              tooltip: 'Teljes képernyő',
              icon: const Icon(Icons.fullscreen),
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildSlideContent(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      // Handle left/right swipes for navigation
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        // Swipe from right to left - go to next slide
        if (details.primaryVelocity! < 0 && currentIndex < totalSlides - 1) {
          ref.read(currentSlideProvider.notifier).changeSlide(1);
        }
        // Swipe from left to right - go to previous slide
        else if (details.primaryVelocity! > 0 && currentIndex > 0) {
          ref.read(currentSlideProvider.notifier).changeSlide(-1);
        }
      },
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: _renderSlideContent(),
      ),
    );
  }

  Widget _renderSlideContent() {
    switch (slide) {
      case SongSlide songSlide:
        return SongSlideView(songSlide, cueUuid);

      case UnknownTypeSlide unknownSlide:
        return UnknownTypeSlideView(unknownSlide);
    }
  }
}

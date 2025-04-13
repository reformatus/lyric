import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/cue/slide.dart';
import '../slide_views/song.dart';
import '../../common/error/card.dart';
import '../state.dart';

/// A dialog that displays a slide in true fullscreen mode
/// Handles entering fullscreen mode and capturing tap gestures for navigation
class FullscreenSlideDialog extends ConsumerStatefulWidget {
  const FullscreenSlideDialog({
    required this.slide,
    required this.cueUuid,
    required this.currentIndex,
    required this.totalSlides,
    this.onClose,
    super.key,
  });

  final Slide slide;
  final String cueUuid;
  final int currentIndex;
  final int totalSlides;
  final VoidCallback? onClose;

  @override
  ConsumerState<FullscreenSlideDialog> createState() =>
      _FullscreenSlideDialogState();
}

class _FullscreenSlideDialogState extends ConsumerState<FullscreenSlideDialog>
    with FullScreenListener {
  bool _showControls = false;
  int _lastTapTime = 0;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    FullScreen.addListener(this);
    _enterFullscreen();
  }

  @override
  void dispose() {
    _exitFullscreen();
    FullScreen.removeListener(this);
    super.dispose();
  }

  Future<void> _enterFullscreen() async {
    FullScreen.setFullScreen(true);
  }

  Future<void> _exitFullscreen() async {
    FullScreen.setFullScreen(false);
  }

  @override
  void onFullScreenChanged(bool enabled, SystemUiMode? systemUiMode) {
    setState(() {
      _isFullScreen = enabled;
    });

    // If user exits fullscreen mode via system UI, close the dialog
    if (!enabled && _isFullScreen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onClose?.call();
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _handleTap(TapUpDetails details) {
    // Check for double tap (custom implementation to avoid conflicts)
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastTapTime < 300) {
      // Double tap detected - exit fullscreen
      widget.onClose?.call();
      return;
    }
    _lastTapTime = now;

    // Single tap - toggle controls visibility
    _toggleControls();

    // If tap is on left third of screen, go to previous slide
    final screenWidth = MediaQuery.of(context).size.width;
    final tapX = details.globalPosition.dx;

    if (tapX < screenWidth / 3) {
      ref.read(currentSlideProvider.notifier).changeSlide(-1);
    }
    // If tap is on right third of screen, go to next slide
    else if (tapX > screenWidth * 2 / 3) {
      ref.read(currentSlideProvider.notifier).changeSlide(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPrevious = widget.currentIndex > 0;
    final hasNext = widget.currentIndex < widget.totalSlides - 1;

    return GestureDetector(
      onTapUp: _handleTap,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        // Swipe left to go to next slide
        if (details.primaryVelocity! < -300 && hasNext) {
          ref.read(currentSlideProvider.notifier).changeSlide(1);
        }
        // Swipe right to go to previous slide
        else if (details.primaryVelocity! > 300 && hasPrevious) {
          ref.read(currentSlideProvider.notifier).changeSlide(-1);
        }
      },
      child: Material(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Slide content
            _renderSlideContent(),

            // Navigation indicators (visible when controls are shown)
            if (_showControls) _buildNavigationOverlay(hasPrevious, hasNext),

            // Slide position indicator (always visible but subtle)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${widget.currentIndex + 1} / ${widget.totalSlides}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationOverlay(bool hasPrevious, bool hasNext) {
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top bar with close button
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            child: IconButton.filled(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close),
              tooltip: 'Exit fullscreen',
              iconSize: 32,
            ),
          ),

          // Bottom bar with navigation buttons
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filled(
                  onPressed:
                      hasPrevious
                          ? () =>
                              ref
                                  .read(currentSlideProvider.notifier)
                                  .changeSlide(-1)
                          : null,
                  icon: const Icon(Icons.navigate_before),
                  tooltip: 'Previous slide',
                  iconSize: 32,
                  style: IconButton.styleFrom(
                    backgroundColor:
                        hasPrevious
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
                const Text(
                  'Tap to toggle controls, double tap to exit',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                IconButton.filled(
                  onPressed:
                      hasNext
                          ? () =>
                              ref
                                  .read(currentSlideProvider.notifier)
                                  .changeSlide(1)
                          : null,
                  icon: const Icon(Icons.navigate_next),
                  tooltip: 'Next slide',
                  iconSize: 32,
                  style: IconButton.styleFrom(
                    backgroundColor:
                        hasNext
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderSlideContent() {
    return switch (widget.slide) {
      SongSlide songSlide => Center(
        child: SongSlideView(songSlide, widget.cueUuid),
      ),
      UnknownTypeSlide unknownSlide => Center(
        child: LErrorCard(
          type: LErrorType.warning,
          title: 'Unknown slide type',
          icon: Icons.question_mark,
          message:
              'This slide has an unknown type. It may have been created with a newer version.',
          stack: unknownSlide.json.toString(),
        ),
      ),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/services/cue/slide/revived_slides.dart';

import '../../data/cue/cue.dart';
import '../../data/cue/slide.dart';
import '../../main.dart';
import '../common/error/card.dart';
import 'widgets/slide_drawer.dart';
import 'widgets/slide_view.dart';
import 'widgets/fullscreen_dialog.dart';

import 'state.dart';

class CuePage extends ConsumerWidget {
  const CuePage(this.uuid, {this.initialSlideUuid, super.key});

  final String uuid;
  final String? initialSlideUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    Cue cue = ref.watch(currentCueProvider)!;
    var slides = ref.watch(revivedSlidesForCueProvider(cue));

    final currentSlide = ref.watch(currentSlideProvider);
    final isTabletOrLarger =
        MediaQuery.of(context).size.width >= globals.tabletFromWidth;

    final bool drawerPermanentlyOpen = isTabletOrLarger;

    // far future todo Update URL when slide changes

    void selectSlide(Slide slide) {
      ref.read(currentSlideProvider.notifier).setCurrent(slide);

      // Close drawer on mobile when a slide is selected
      if (MediaQuery.of(context).size.width < globals.tabletFromWidth) {
        scaffoldKey.currentState?.closeDrawer();
      }
    }

    void showFullscreenDialog(Slide slide, int currentIndex, int totalSlides) {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black,
        builder:
            (context) => FullscreenSlideDialog(
              slide: slide,
              cueUuid: uuid,
              currentIndex: currentIndex,
              totalSlides: totalSlides,
              onClose: () => Navigator.of(context).pop(),
            ),
      );
    }

    void showAddSongDialog() {
      showDialog(
        context: context,
        builder: (context) => AddSongDialog(cueUuid: uuid),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(cue.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Ének hozzáadása',
            onPressed: showAddSongDialog,
          ),
        ],
      ),
      drawer: !drawerPermanentlyOpen ? SlideDrawer(cue: cue) : null,
      body: SafeArea(
        child: Row(
          children: [
            if (drawerPermanentlyOpen)
              SizedBox(width: 300, child: SlideDrawer(cue: cue)),

            // Main content area
            Expanded(
              child: _buildMainContent(
                slides,
                currentSlide,
                showFullscreenDialog,
                selectSlide,
                uuid,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          !drawerPermanentlyOpen && currentSlide == null
              ? FloatingActionButton.extended(
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
                label: const Text('Show Slides'),
                icon: const Icon(Icons.menu),
              )
              : null,
    );
  }

  Widget _buildMainContent(
    AsyncValue<List<Slide>?> slides,
    Slide? currentSlide,
    Function(Slide, int, int) showFullscreenDialog,
    Function(Slide) selectSlide,
    String cueUuid,
  ) {
    if (slides is AsyncError) {
      return Center(
        child: LErrorCard(
          type: LErrorType.error,
          title: 'Failed to load slides',
          icon: Icons.error,
          message: slides.error.toString(),
          stack: slides.stackTrace.toString(),
        ),
      );
    }

    if (slides is AsyncLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final slidesValue = slides.value ?? [];

    if (currentSlide == null || slidesValue.isEmpty) {
      return const Center(
        child: Text('Select a slide or add new slides to start'),
      );
    }

    // Find the current slide index (for navigation)
    final currentIndex = slidesValue.indexWhere(
      (s) => s.uuid == currentSlide.uuid,
    );
    if (currentIndex == -1) {
      // If selected slide isn't found, select the first slide
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (slidesValue.isNotEmpty) {
          selectSlide(slidesValue[0]);
        }
      });
      return const Center(child: CircularProgressIndicator());
    }

    return SlideView(
      slide: currentSlide,
      cueUuid: cueUuid,
      currentIndex: currentIndex,
      totalSlides: slidesValue.length,
      onTap:
          () => showFullscreenDialog(
            currentSlide,
            currentIndex,
            slidesValue.length,
          ),
    );
  }
}

/// Dialog for adding songs to the cue
/// This is a placeholder - you'll implement proper song adding later
class AddSongDialog extends StatelessWidget {
  const AddSongDialog({required this.cueUuid, super.key});

  final String cueUuid;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Songs'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Text(
            'Song adding will be implemented later',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}

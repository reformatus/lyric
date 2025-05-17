import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/ui/cue/state.dart';
import 'package:lyric/ui/cue/widgets/slide_view.dart';

import '../../../../data/cue/cue.dart';

/*
 * // TODO finish
 * 
 * Diaszám jelző dizájn
 * Nagyíthatóság és görgethetőség
 * Váltás koppintással
 */

class CuePresentMusicianPage extends ConsumerStatefulWidget {
  const CuePresentMusicianPage(this.cue, {super.key});

  final Cue cue;

  @override
  ConsumerState<CuePresentMusicianPage> createState() =>
      _CuePresentMusicianPageState();
}

class _CuePresentMusicianPageState extends ConsumerState<CuePresentMusicianPage>
    with TickerProviderStateMixin {
  late final AnimationController overlayController;
  late final Animation<double> overlayAnimation;

  @override
  void initState() {
    overlayController = AnimationController(
      vsync: this,
      duration: Durations.long1,
      value: 1,
    );
    overlayAnimation = CurvedAnimation(
      parent: overlayController,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        Duration(milliseconds: 500),
      ).then((_) => overlayController.reverse()),
    );

    super.initState();
    FullScreen.setFullScreen(true);
  }

  @override
  void dispose() {
    super.dispose();
    FullScreen.setFullScreen(false);
  }

  Timer? overlayCloser;
  void resetOverlayCloser() {
    overlayCloser?.cancel();
    overlayCloser = Timer(
      Duration(seconds: 3),
      () => overlayController.reverse(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var slideIndex =
        ref.watch(watchSlideIndexOfCueProvider(widget.cue)).valueOrNull;

    return Scaffold(
      body: AnimatedBuilder(
        animation: overlayAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              GestureDetector(
                onTap: () {
                  if (overlayController.isCompleted) {
                    overlayController.reverse();
                  } else if (overlayController.isDismissed) {
                    overlayController.forward();
                    resetOverlayCloser();
                  }
                },
                onDoubleTap: () => context.pop,
                child: SizedBox.expand(
                  child: Container(
                    color: Colors.black.withAlpha(
                      Tween<double>(
                        begin: 0,
                        end: 80,
                      ).animate(overlayAnimation).value.floor(),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: FractionalTranslation(
                  translation: Offset(
                    0,
                    Tween<double>(
                      begin: -1.5,
                      end: 0,
                    ).animate(overlayAnimation).value,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: FloatingActionButton(
                      onPressed: context.pop,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              if (hasPreviousSlide(slideIndex))
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionalTranslation(
                    translation: Offset(
                      Tween<double>(
                        begin: -1.5,
                        end: 0,
                      ).animate(overlayAnimation).value,
                      0,
                    ),
                    child: SizedBox(
                      height: 90,
                      width: 50,
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(
                                  currentSlideOfProvider(widget.cue).notifier,
                                )
                                .changeSlide(-1);
                            resetOverlayCloser();
                          },
                          child: Center(
                            child: Icon(Icons.chevron_left, size: 30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (hasNextSlide(slideIndex))
                Align(
                  alignment: Alignment.centerRight,
                  child: FractionalTranslation(
                    translation: Offset(
                      Tween<double>(
                        begin: 1.5,
                        end: 0,
                      ).animate(overlayAnimation).value,
                      0,
                    ),
                    child: SizedBox(
                      height: 90,
                      width: 50,
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(
                                  currentSlideOfProvider(widget.cue).notifier,
                                )
                                .changeSlide(1);
                            resetOverlayCloser();
                          },
                          child: Center(
                            child: Icon(Icons.chevron_right, size: 30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: FractionalTranslation(
                    translation: Offset(
                      0,
                      Tween<double>(
                        begin: 1.5,
                        end: 0,
                      ).animate(overlayAnimation).value,
                    ),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          '${(slideIndex?.index ?? 0) + 1} / ${slideIndex?.total}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: Hero(tag: 'CueSlideView', child: SlideView(widget.cue)),
      ),
    );
  }
}

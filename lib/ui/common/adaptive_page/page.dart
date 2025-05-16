import 'dart:math';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:lyric/main.dart';

class AdaptivePage extends StatefulWidget {
  const AdaptivePage({
    required this.title,
    required this.body,
    this.rightDrawer,
    this.rightDrawerScrollable = false,
    this.leftDrawer,
    this.leftDrawerScrollable = false,
    this.actionBarChildren,
    this.actionBarTrailingChildren,
    super.key,
  });

  final String title;
  final Widget? rightDrawer;
  // TODO fix scrollable
  final bool rightDrawerScrollable;
  final Widget? leftDrawer;
  final bool leftDrawerScrollable;
  final List<Widget>? actionBarChildren;
  final List<Widget>? actionBarTrailingChildren;
  final Widget body;

  @override
  State<AdaptivePage> createState() => _AdaptivePageState();
}

class _AdaptivePageState extends State<AdaptivePage>
    with TickerProviderStateMixin {
  late final ScrollController leftDrawerScrollController;
  late final AnimationController leftDrawerController;
  late final Animation<double> leftDrawerAnimation;
  late final ScrollController rightDrawerScrollController;
  late final AnimationController rightDrawerController;
  late final Animation<double> rightDrawerAnimation;

  @override
  void initState() {
    leftDrawerScrollController = ScrollController();
    rightDrawerScrollController = ScrollController();

    leftDrawerController = AnimationController(
      vsync: this,
      value: 1,
      duration: Durations.medium2,
    );

    rightDrawerController = AnimationController(
      vsync: this,
      value: 1,
      duration: Durations.medium2,
    );

    leftDrawerAnimation = CurvedAnimation(
      parent: leftDrawerController,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );

    rightDrawerAnimation = CurvedAnimation(
      parent: rightDrawerController,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool wideLayout = constraints.maxWidth > globals.tabletFromWidth;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            leading: BackButton(),
            automaticallyImplyLeading: false,
            actions: [
              SizedBox.shrink(),
              if (!wideLayout) ...widget.actionBarTrailingChildren ?? [],
            ],
          ),
          drawer:
              wideLayout || widget.leftDrawer == null
                  ? null
                  : Drawer(child: SafeArea(child: widget.leftDrawer!)),
          endDrawer:
              wideLayout || widget.rightDrawer == null
                  ? null
                  : Drawer(child: SafeArea(child: widget.rightDrawer!)),
          body: Builder(
            builder: (context) {
              return Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Stack(
                  children: [
                    if (widget.leftDrawer != null && wideLayout)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedBuilder(
                          animation: leftDrawerAnimation,
                          builder: (context, _) {
                            return FractionalTranslation(
                              translation:
                                  Tween<Offset>(
                                    begin: Offset(-1, 0),
                                    end: Offset.zero,
                                  ).animate(leftDrawerAnimation).value,
                              child: SizedBox(
                                width: max(constraints.maxWidth / 5, 250),
                                child: Drawer(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child:
                                      widget.leftDrawerScrollable
                                          ? FadingEdgeScrollView.fromSingleChildScrollView(
                                            child: SingleChildScrollView(
                                              controller:
                                                  leftDrawerScrollController,
                                              child: widget.leftDrawer,
                                            ),
                                          )
                                          : widget.leftDrawer,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (widget.rightDrawer != null && wideLayout)
                      Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedBuilder(
                          animation: rightDrawerAnimation,
                          builder: (context, _) {
                            return FractionalTranslation(
                              translation:
                                  Tween<Offset>(
                                    begin: Offset(1, 0),
                                    end: Offset.zero,
                                  ).animate(rightDrawerAnimation).value,
                              child: SizedBox(
                                width: max(constraints.maxWidth / 5, 250),
                                child: Drawer(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child:
                                      widget.leftDrawerScrollable
                                          ? FadingEdgeScrollView.fromSingleChildScrollView(
                                            child: SingleChildScrollView(
                                              controller:
                                                  rightDrawerScrollController,
                                              child: widget.rightDrawer,
                                            ),
                                          )
                                          : widget.rightDrawer,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    Row(
                      children: [
                        if (widget.leftDrawer != null && wideLayout)
                          AnimatedBuilder(
                            animation: leftDrawerAnimation,
                            builder: (context, _) {
                              return SizedBox(
                                width:
                                    max(constraints.maxWidth / 5, 250) *
                                    leftDrawerAnimation.value,
                              );
                            },
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              if (!wideLayout) Expanded(child: widget.body),
                              Container(
                                height: 50,
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    if (widget.leftDrawer != null && wideLayout)
                                      IconButton.filledTonal(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: leftDrawerController.toggle,
                                        icon: RotationTransition(
                                          turns: Tween<double>(
                                            begin: 0,
                                            end: 0.5,
                                          ).animate(leftDrawerAnimation),
                                          child: Icon(
                                            Icons.chevron_right,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    if (widget.leftDrawer != null &&
                                        !wideLayout)
                                      IconButton.filledTonal(
                                        visualDensity: VisualDensity.compact,
                                        onPressed:
                                            Scaffold.of(context).openDrawer,
                                        icon: Icon(
                                          Icons.chevron_right,
                                          size: 20,
                                        ),
                                      ),
                                    ...widget.actionBarChildren ?? [],
                                    Spacer(),
                                    if (wideLayout)
                                      ...widget.actionBarTrailingChildren ?? [],
                                    if (widget.rightDrawer != null &&
                                        wideLayout)
                                      IconButton.filledTonal(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: rightDrawerController.toggle,
                                        icon: RotationTransition(
                                          turns: Tween<double>(
                                            begin: 0,
                                            end: 0.5,
                                          ).animate(rightDrawerAnimation),
                                          child: Icon(
                                            Icons.chevron_left,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    if (widget.rightDrawer != null &&
                                        !wideLayout)
                                      IconButton.filledTonal(
                                        visualDensity: VisualDensity.compact,
                                        onPressed:
                                            Scaffold.of(context).openEndDrawer,
                                        icon: Icon(
                                          Icons.chevron_left,
                                          size: 20,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (wideLayout) Expanded(child: widget.body),
                            ],
                          ),
                        ),
                        if (widget.rightDrawer != null && wideLayout)
                          AnimatedBuilder(
                            animation: rightDrawerAnimation,
                            builder: (context, _) {
                              return SizedBox(
                                width:
                                    max(constraints.maxWidth / 5, 250) *
                                    rightDrawerAnimation.value,
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

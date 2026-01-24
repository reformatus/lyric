import 'dart:math';

import 'package:flutter/material.dart';
import '../../../config/config.dart';
import 'drawer_button.dart';

class AdaptivePage extends StatefulWidget {
  const AdaptivePage({
    required this.title,
    required this.body,
    this.subtitle,
    this.leftDrawer,
    this.leftDrawerIcon,
    this.leftDrawerTooltip,
    this.rightDrawer,
    this.rightDrawerIcon,
    this.rightDrawerTooltip,
    this.actionBarChildren,
    this.actionBarTrailingChildren,
    this.bodyHeroTag,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leftDrawer;
  final IconData? leftDrawerIcon;
  final String? leftDrawerTooltip;
  final Widget? rightDrawer;
  final IconData? rightDrawerIcon;
  final String? rightDrawerTooltip;
  final List<Widget>? actionBarChildren;
  final List<Widget>? actionBarTrailingChildren;
  final Widget body;
  final String? bodyHeroTag;

  @override
  State<AdaptivePage> createState() => _AdaptivePageState();
}

class _AdaptivePageState extends State<AdaptivePage>
    with TickerProviderStateMixin {
  late final AnimationController leftDrawerController;
  late final Animation<double> leftDrawerAnimation;
  late final AnimationController rightDrawerController;
  late final Animation<double> rightDrawerAnimation;

  @override
  void initState() {
    leftDrawerController = AnimationController(
      vsync: this,
      value: 0,
      duration: Durations.medium2,
    );

    rightDrawerController = AnimationController(
      vsync: this,
      value: 0,
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

  int previousAnimation = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool tabletOrBigger =
          constraints.maxWidth > appConfig.breakpoints.tabletFromWidth;
        bool desktopOrBigger =
          constraints.maxWidth > appConfig.breakpoints.desktopFromWidth;

        if (!tabletOrBigger && previousAnimation != 1) {
          leftDrawerController.reverse(from: previousAnimation != 0 ? null : 1);
          rightDrawerController.reverse(
            from: previousAnimation != 0 ? null : 0,
          );
          previousAnimation = 1;
        } else if (tabletOrBigger &&
            !desktopOrBigger &&
            previousAnimation != 2) {
          leftDrawerController.forward(from: previousAnimation != 0 ? null : 0);
          rightDrawerController.reverse(
            from: previousAnimation != 0 ? null : 1,
          );
          previousAnimation = 2;
        } else if (desktopOrBigger && previousAnimation != 3) {
          leftDrawerController.forward(from: previousAnimation != 0 ? null : 0);
          rightDrawerController.forward(
            from: previousAnimation != 0 ? null : 0,
          );
          previousAnimation = 3;
        }
        return ClipRect(
          child: Scaffold(
            appBar: AppBar(
              title: widget.subtitle != null && widget.subtitle!.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        ),
                        Text(
                          widget.subtitle!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .appBarTheme
                                    .foregroundColor
                                    ?.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    )
                  : Text(widget.title),
              leading: BackButton(),
              automaticallyImplyLeading: false,
              actions: [
                SizedBox.shrink(),
                if (!tabletOrBigger) ...widget.actionBarTrailingChildren ?? [],
                SizedBox(width: 8),
              ],
            ),
            drawer: tabletOrBigger || widget.leftDrawer == null
                ? null
                : Drawer(child: SafeArea(child: widget.leftDrawer!)),
            endDrawer: tabletOrBigger || widget.rightDrawer == null
                ? null
                : Drawer(child: SafeArea(child: widget.rightDrawer!)),
            body: Builder(
              builder: (context) {
                return Container(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          if (widget.leftDrawer != null && tabletOrBigger)
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
                                if (!tabletOrBigger) _buildBody(),
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      if (widget.leftDrawer != null)
                                        AdaptivePageDrawerButton(
                                          onPressed: tabletOrBigger
                                              ? leftDrawerController.toggle
                                              : Scaffold.of(context).openDrawer,
                                          animation: leftDrawerAnimation,
                                          drawerIcon: widget.leftDrawerIcon,
                                          tooltip: widget.leftDrawerTooltip,
                                        ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: Row(
                                            children: [
                                              ...widget.actionBarChildren ?? [],
                                              Spacer(),
                                              if (tabletOrBigger)
                                                ...widget
                                                        .actionBarTrailingChildren ??
                                                    [],
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (widget.rightDrawer != null)
                                        AdaptivePageDrawerButton(
                                          onPressed: tabletOrBigger
                                              ? rightDrawerController.toggle
                                              : Scaffold.of(
                                                  context,
                                                ).openEndDrawer,
                                          animation: rightDrawerAnimation,
                                          drawerIcon: widget.rightDrawerIcon,
                                          tooltip: widget.rightDrawerTooltip,
                                          endDrawer: true,
                                        ),
                                    ],
                                  ),
                                ),
                                if (tabletOrBigger) _buildBody(),
                              ],
                            ),
                          ),

                          if (widget.rightDrawer != null && tabletOrBigger)
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
                      if (widget.leftDrawer != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedBuilder(
                            animation: leftDrawerAnimation,
                            builder: (context, _) {
                              return FractionalTranslation(
                                translation: Tween<Offset>(
                                  begin: Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(leftDrawerAnimation).value,
                                child: SizedBox(
                                  width: max(constraints.maxWidth / 5, 250),
                                  child: Drawer(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: widget.leftDrawer,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (widget.rightDrawer != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedBuilder(
                            animation: rightDrawerAnimation,
                            builder: (context, _) {
                              return FractionalTranslation(
                                translation: Tween<Offset>(
                                  begin: Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(rightDrawerAnimation).value,
                                child: SizedBox(
                                  width: max(constraints.maxWidth / 5, 250),
                                  child: Drawer(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                      ),
                                    ),
                                    child: widget.rightDrawer,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Expanded _buildBody() {
    return Expanded(
      child: widget.bodyHeroTag != null
          ? Hero(tag: widget.bodyHeroTag!, child: widget.body)
          : widget.body,
    );
  }

  @override
  void dispose() {
    leftDrawerController.dispose();
    rightDrawerController.dispose();
    super.dispose();
  }
}

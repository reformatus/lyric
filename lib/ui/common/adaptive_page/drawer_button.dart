import 'package:flutter/material.dart';

class AdaptivePageDrawerButton extends StatelessWidget {
  const AdaptivePageDrawerButton({
    required this.onPressed,
    required this.animation,
    this.endDrawer = false,
    this.drawerIcon,
    this.tooltip,
    super.key,
  });

  final VoidCallback onPressed;
  final Animation<double> animation;
  final bool endDrawer;
  final IconData? drawerIcon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [
      RotationTransition(
        turns: Tween<double>(
          begin: endDrawer ? 0.5 : 0,
          end: endDrawer ? 0 : 0.5,
        ).animate(animation),
        child: Icon(
          Icons.chevron_right,
          size: 20,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      if (drawerIcon != null)
        Icon(drawerIcon, color: Theme.of(context).colorScheme.onPrimary),
    ];

    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.only(
            topRight: !endDrawer ? Radius.circular(15) : Radius.zero,
            bottomRight: !endDrawer ? Radius.circular(15) : Radius.zero,
            topLeft: endDrawer ? Radius.circular(15) : Radius.zero,
            bottomLeft: endDrawer ? Radius.circular(15) : Radius.zero,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Theme.of(context).colorScheme.primary,

          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Row(
                children:
                    endDrawer ? rowChildren.reversed.toList() : rowChildren,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

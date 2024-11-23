import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/main.dart';

typedef GeneralNavigationDestination = ({
  IconData icon,
  IconData? selectedIcon,
  String label,
});

NavigationDestination destinationFromGeneral(GeneralNavigationDestination d) => NavigationDestination(
      icon: Icon(d.icon),
      selectedIcon: d.selectedIcon != null ? Icon(d.selectedIcon) : null,
      label: d.label,
    );

NavigationRailDestination railDestinationFromGeneral(GeneralNavigationDestination d) =>
    NavigationRailDestination(
      icon: Icon(d.icon),
      selectedIcon: d.selectedIcon != null ? Icon(d.selectedIcon) : null,
      label: Text(d.label),
    );

class BaseScaffold extends StatefulWidget {
  const BaseScaffold({required this.child, super.key});

  final Widget child;

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/bank')) {
      return 1;
    }
    if (location.startsWith('/sets')) {
      return 2;
    }
    if (location.startsWith('/song')) {
      return 3;
    }
    if (location.startsWith('/cue')) {
      return 3;
    }
    return 0;
  }
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  void initState() {
    super.initState();
    //extendedNavRail = MediaQuery.of(context).size.width > globals.desktopFromWidth;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        extendedNavRail = MediaQuery.of(context).size.width > globals.desktopFromWidth;
      });
    });
  }

  bool extendedNavRail = true;

  @override
  Widget build(BuildContext context) {
    final List<GeneralNavigationDestination> destinations = [
      (
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Főoldal',
      ),
      (
        icon: Icons.library_music_outlined,
        selectedIcon: Icons.library_music,
        label: 'Daltár',
      ),
      (
        icon: Icons.view_list_outlined,
        selectedIcon: Icons.view_list,
        label: 'Listáim',
      ),
      if (GoRouterState.of(context).uri.path.startsWith('/song'))
        (
          icon: Icons.music_note_outlined,
          selectedIcon: Icons.music_note,
          label: 'Dal',
        ),
      if (GoRouterState.of(context).uri.path.startsWith('/cue'))
        (
          icon: Icons.list,
          selectedIcon: Icons.list,
          label: 'Lista',
        ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      // most songs are A4, this way we have the highest chance of fitting the song on the screen the biggest possible
      bool bottomNavBar = constraints.maxHeight / constraints.maxWidth > 1.41;
      return Scaffold(
        bottomNavigationBar: bottomNavBar
            ? NavigationBar(
                labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                height: 65,
                destinations: destinations.map((d) => destinationFromGeneral(d)).toList(),
                selectedIndex: BaseScaffold._calculateSelectedIndex(context),
                onDestinationSelected: (int index) => _onDestinationSelected(index, context),
              )
            : null,
        body: !bottomNavBar
            ? Row(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: AnimatedSize(
                      duration: Durations.medium1,
                      curve: Curves.easeInOutCubicEmphasized,
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        children: [
                          NavigationRail(
                            extended: extendedNavRail,
                            labelType: extendedNavRail
                                ? NavigationRailLabelType.none
                                : NavigationRailLabelType.selected,
                            destinations: destinations.map((d) => railDestinationFromGeneral(d)).toList(),
                            selectedIndex: BaseScaffold._calculateSelectedIndex(context),
                            onDestinationSelected: (int index) => _onDestinationSelected(index, context),
                            backgroundColor: Colors.transparent,
                            minExtendedWidth: 160,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(extendedNavRail ? Icons.chevron_left : Icons.chevron_right),
                              onPressed: () {
                                setState(() {
                                  extendedNavRail = !extendedNavRail;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: widget.child)
                ],
              )
            : widget.child,
      );
    });
  }

  void _onDestinationSelected(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
      case 1:
        GoRouter.of(context).go('/bank');
      case 2:
        GoRouter.of(context).go('/sets');
      default:
        return;
    }
  }
}

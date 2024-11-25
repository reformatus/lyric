import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../services/app_version/check_new_version.dart';

typedef GeneralNavigationDestination = ({
  Widget icon,
  Widget? selectedIcon,
  String label,
});

NavigationDestination destinationFromGeneral(GeneralNavigationDestination d) => NavigationDestination(
      icon: d.icon,
      selectedIcon: d.selectedIcon ?? d.icon,
      label: d.label,
    );

NavigationRailDestination railDestinationFromGeneral(GeneralNavigationDestination d) =>
    NavigationRailDestination(
      icon: d.icon,
      selectedIcon: d.selectedIcon ?? d.icon,
      label: Text(d.label),
    );

class BaseScaffold extends ConsumerStatefulWidget {
  const BaseScaffold({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<BaseScaffold> createState() => _BaseScaffoldState();

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

class _BaseScaffoldState extends ConsumerState<BaseScaffold> {
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
    final newVersion = ref.watch(checkNewVersionProvider);

    final List<GeneralNavigationDestination> destinations = [
      (
        icon: Badge(isLabelVisible: newVersion.valueOrNull != null, child: Icon(Icons.home_outlined)),
        selectedIcon: Icon(Icons.home),
        label: 'Főoldal',
      ),
      (
        icon: Icon(Icons.library_music_outlined),
        selectedIcon: Icon(Icons.library_music),
        label: 'Daltár',
      ),
      (
        icon: Icon(Icons.view_list_outlined),
        selectedIcon: Icon(Icons.view_list),
        label: 'Listáim',
      ),
      if (GoRouterState.of(context).uri.path.startsWith('/song'))
        (
          icon: Icon(Icons.music_note_outlined),
          selectedIcon: Icon(Icons.music_note),
          label: 'Dal',
        ),
      if (GoRouterState.of(context).uri.path.startsWith('/cue'))
        (
          icon: Icon(Icons.list),
          selectedIcon: Icon(Icons.list),
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

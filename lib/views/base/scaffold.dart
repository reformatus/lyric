import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Főoldal',
          ),
          const NavigationDestination(
            icon: Icon(Icons.library_music),
            label: 'Daltár',
          ),
          const NavigationDestination(
            icon: Icon(Icons.view_list),
            label: 'Listáim',
          ),
          if (GoRouterState.of(context).uri.path.startsWith('/song'))
            const NavigationDestination(
              icon: Icon(Icons.music_note),
              label: 'Dal',
            )
        ],
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int index) =>
            _onDestinationSelected(index, context),
      ),
    );
  }

// @see https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/shell_route.dart

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
    return 0;
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

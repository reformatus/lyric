import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/base/home/page.dart';
import 'package:lyric/base/scaffold.dart';

import 'base/bank/page.dart';
import 'base/sets/page.dart';

void main() {
  runApp(const LyricApp());
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _baseNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'base');

class LyricApp extends StatelessWidget {
  const LyricApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        theme: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.orange, brightness: Brightness.dark),
            useMaterial3: true),
        routerConfig: _router);
  }
}

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _baseNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return BaseScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const MaterialPage(
            child: HomePage(),
          ),
        ),
        GoRoute(
          path: '/bank',
          pageBuilder: (context, state) => const MaterialPage(
            child: BankPage(),
          ),
        ),
        GoRoute(
          path: '/sets',
          pageBuilder: (context, state) => const MaterialPage(
            child: SetsPage(),
          ),
        ),
      ],
    )
  ],
);

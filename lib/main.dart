import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/views/base/home/page.dart';
import 'package:lyric/views/base/scaffold.dart';
import 'package:path_provider/path_provider.dart';

import 'views/base/bank/page.dart';
import 'views/base/sets/page.dart';
import 'views/loading/page.dart';

late final Directory dataDir;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dataDir = await getApplicationDocumentsDirectory();

  runApp(const ProviderScope(child: LyricApp()));
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
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      pageBuilder: (context, state) => const MaterialPage(
        child: LoadingPage(),
      ),
    ),
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

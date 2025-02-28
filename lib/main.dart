import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import 'data/database.dart';
import 'ui/base/cues/page.dart';
import 'ui/base/home/page.dart';
import 'ui/base/scaffold.dart';
import 'ui/base/songs/page.dart';
import 'ui/cue/page.dart';
import 'ui/loading/page.dart';
import 'ui/song/page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dataDir = await getApplicationDocumentsDirectory();
  db = LyricDatabase();

  runApp(const ProviderScope(child: LyricApp()));
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _baseNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'base',
);

final globals = (
  tabletFromWidth: 700,
  desktopFromWidth: 1000,
  isDesktop: Platform.isMacOS || Platform.isWindows || Platform.isLinux,
  isMobile: Platform.isIOS || Platform.isAndroid,
  gitHubApiRoot: 'https://api.github.com/repos/reformatus/lyric',
  scaffoldKey: GlobalKey<ScaffoldMessengerState>(),
  router: _router,
);

class LyricApp extends StatelessWidget {
  const LyricApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff025462),
          primary: Color(0xffc3a140),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      scaffoldMessengerKey: globals.scaffoldKey,
      routerConfig: _router,
      supportedLocales: const [Locale('hu')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      pageBuilder: (context, state) => const MaterialPage(child: LoadingPage()),
    ),
    ShellRoute(
      navigatorKey: _baseNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return BaseScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) {
            return const MaterialPage(child: HomePage());
          },
        ),
        GoRoute(
          path: '/bank',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SongsPage());
          },
        ),
        GoRoute(
          path: '/sets',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SetsPage());
          },
        ),
        GoRoute(
          path: '/song/:uuid',
          pageBuilder: (context, state) {
            final songUuid = state.pathParameters['uuid']!;
            return MaterialPage(child: SongPage(songUuid));
          },
        ),
        GoRoute(
          path: '/cue/:uuid',
          pageBuilder: (context, state) {
            final cueUuid = state.pathParameters['uuid']!;
            int? slideIndex = int.tryParse(
              state.uri.queryParameters['index'] ?? 'ignoreMe',
            );
            return MaterialPage(
              child: CuePage(cueUuid, initialSlideIndex: slideIndex),
            );
          },
        ),
      ],
    ),
  ],
);

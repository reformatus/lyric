part of 'main.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> baseNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'base',
);

final appRouter = GoRouter(
  navigatorKey: appNavigatorKey,
  initialLocation: '/loading',
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/loading'),
    GoRoute(
      path: '/loading',
      pageBuilder: (context, state) => const MaterialPage(child: LoadingPage()),
    ),
    ShellRoute(
      navigatorKey: baseNavigatorKey,
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
          path: '/cues',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SetsPage());
          },
        ),
        GoRoute(
          path: '/song/:uuid',
          pageBuilder: (context, state) =>
              MaterialPage(child: SongPage(state.pathParameters['uuid']!)),
          /*routes: [ // far future todo direct links to pages
            ShellRoute(
              pageBuilder:
                  (context, state, child) => MaterialPage(
                    child: SongPage(state.pathParameters['uuid']!, child),
                  ),
              routes: [
                GoRoute(
                  path: '/svg',
                  builder:
                      (context, state) =>
                          SheetView.svg(state.pathParameters['uuid']!),
                ),
                GoRoute(
                  path: '/pdf',
                  builder:
                      (context, state) =>
                          SheetView.pdf(state.pathParameters['uuid']!),
                ),
                GoRoute(
                  path: '/lyrics',
                  builder:
                      (context, state) =>
                          LyricsView(state.pathParameters['uuid']!),
                ),
              ],
            ),
          ],*/
        ),
        GoRoute(
          path: '/cue/:uuid/edit',
          pageBuilder: (context, state) {
            final cueUuid = state.pathParameters['uuid']!;
            final slideUuid = state.uri.queryParameters['slide'];
            return MaterialPage(
              child: CueLoaderPage(
                cueUuid,
                CuePageType.edit,
                initialSlideUuid: slideUuid,
              ),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/cue/:uuid/present',
      //redirect: (context, state) => '/cues',
      builder: (context, state) =>
          Scaffold(body: Center(child: Text('Nincs megadva nézet'))),
      routes: [
        GoRoute(
          path: 'musician',

          pageBuilder: (context, state) {
            final cueUuid = state.pathParameters['uuid']!;
            final slideUuid = state.uri.queryParameters['slide'];
            return MaterialPage(
              child: CueLoaderPage(
                cueUuid,
                CuePageType.musician,
                initialSlideUuid: slideUuid,
              ),
            );
          },
        ),
        // far future todo
        // GoRoute(path: 'stage'),
        // GoRoute(path: 'projector'),
      ],
    ),
    // far future todo
    //GoRoute(path: '/cue/:uuid/control'),
  ],
);

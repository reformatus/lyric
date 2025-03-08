part of 'main.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _baseNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'base',
);

Map<String, GlobalKey<NavigatorState>> _songNavigatorKeys = {};

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
          pageBuilder:
              (context, state) => MaterialPage(
                child: SongPage(state.pathParameters['uuid']!),
              ),
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
          path: '/cue/:uuid',
          pageBuilder: (context, state) {
            final cueUuid = state.pathParameters['uuid']!;
            int? slideIndex = int.tryParse(
              state.uri.queryParameters['index'] ?? 'return null',
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

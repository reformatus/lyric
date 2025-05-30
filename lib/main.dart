import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/ui/cue/state.dart';
import 'package:path_provider/path_provider.dart';

import 'data/database.dart';
import 'data/log/logger.dart';
import 'ui/base/cues/page.dart';
import 'ui/base/home/page.dart';
import 'ui/base/scaffold.dart';
import 'ui/base/songs/page.dart';
import 'ui/cue/loader.dart';
import 'ui/loading/page.dart';
import 'ui/song/page.dart';

part 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FullScreen.ensureInitialized();
  dataDir = await getApplicationDocumentsDirectory();
  db = LyricDatabase();

  runApp(const ProviderScope(child: LyricApp()));
}

final globals = (
  isDesktop: Platform.isMacOS || Platform.isWindows || Platform.isLinux,
  isMobile: Platform.isIOS || Platform.isAndroid,
  isWeb: kIsWeb,
  scaffoldKey: GlobalKey<ScaffoldMessengerState>(),
  router: _router,
);

const constants = (
  appName: 'Sófár DalApp',
  organisationName: 'Sófár',
  gitHubApiRoot: 'https://api.github.com/repos/reformatus/lyric',
  domain: 'app.sofarkotta.hu',
  homepageRoot: 'https://app.sofarkotta.hu',
  apiRoot: 'https://app.sofarkotta.hu/api',
  webappRoot: 'https://app.sofarkotta.hu/web',
  urlScheme: 'lyric',
  tabletFromWidth: 700,
  desktopFromWidth: 1000,
);

class LyricApp extends ConsumerStatefulWidget {
  const LyricApp({super.key});

  @override
  ConsumerState<LyricApp> createState() => _LyricAppState();
}

class _LyricAppState extends ConsumerState<LyricApp> {
  @override
  void initState() {
    initLogger(ref);
    super.initState();
  }

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

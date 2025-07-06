import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:go_router/go_router.dart';
import 'services/preferences/provider.dart';
import 'ui/cue/state.dart';
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
  dio: Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 10),
    ),
  ),
);

const constants = (
  appName: 'Sófár DalApp',
  organisationName: 'Sófár',
  gitHubApiRoot: 'https://api.github.com/repos/reformatus/lyric',
  domain: 'app.sofarkotta.hu',
  homepageRoot: 'https://app.sofarkotta.hu',
  apiRoot: 'https://app.sofarkotta.hu/api',
  webappRoot: 'https://app.sofarkotta.hu/web',
  newsRss: 'https://testpress.server.fodor.pro/category/app/aktualis/feed',
  buttonsRss: 'https://testpress.server.fodor.pro/category/app/linkek/feed',
  urlScheme: 'lyric',
  tabletFromWidth: 700.0,
  desktopFromWidth: 1000.0,
  seedColor: Color(0xff025462),
  primaryColor: Color(0xffc3a140),
);

String? get storeLinkForCurrentPlatform {
  if (Platform.isAndroid) {
    return 'https://play.google.com/store/apps/details?id=org.lyricapp.sofar';
  }
  // TODO will this change with app name change?
  /*if (Platform.isIOS) {
    return 'https://apps.apple.com/us/app/s%C3%B3f%C3%A1r-dalapp/id6738664835';
  }*/

  return null;
}

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
    final generalPrefs = ref.watch(generalPreferencesProvider);

    return MaterialApp.router(
      themeMode: generalPrefs.appBrightness,
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: constants.seedColor,
          primary: constants.primaryColor,
          surface: generalPrefs.oledBlackBackground ? Colors.black : null,
          brightness: Brightness.dark,
        ),
      ),
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: constants.seedColor,
          primary: constants.primaryColor,
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

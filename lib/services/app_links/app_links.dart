import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../cue/import_from_link.dart';
import '../../ui/common/error/card.dart';
import '../../ui/common/error/dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/log/logger.dart';

part 'app_links.g.dart';

final appLinksSingleton = AppLinks();

@Riverpod(keepAlive: true)
Stream<String> shouldNavigate(Ref ref) async* {
  await for (Uri uri in appLinksSingleton.uriLinkStream) {
    log.info(
      'Bejövő link kezelése: "${uri.toString().substring(0, uri.toString().length.clamp(0, 100))}"',
    );
    try {
      if (uri.scheme != constants.urlScheme &&
          uri.authority != constants.domain) {
        continue;
      }
      if (uri.pathSegments.isEmpty) continue;
      switch (uri.pathSegments[0]) {
        case 'launch':
          if (uri.pathSegments.length < 2) continue;
          switch (uri.pathSegments[1]) {
            case 'cueData':
              try {
                String? encodedData = uri.queryParameters['data'];
                if (encodedData == null) continue;

                final result = await importCueFromCompressedData(
                  encodedData,
                  uri.queryParameters,
                );

                yield result.getNavigationPath();
              } catch (e) {
                throw Exception('Hibás lista a linkben:\n$e');
              }
            case 'cueJson':
              try {
                String? jsonString = uri.queryParameters['data'];
                if (jsonString == null) continue;

                final result = await importCueFromJson(
                  jsonString,
                  uri.queryParameters,
                );

                yield result.getNavigationPath();
              } catch (e) {
                throw Exception('Hibás lista a linkben:\n$e');
              }
            case '':
            case '/':
              continue;
            default:
              yield Uri(
                pathSegments: uri.pathSegments.skip(1),
                query: uri.query,
                fragment: uri.fragment.isEmpty ? null : uri.fragment,
              ).toString();
          }
          break;
        case '':
        case '/':
          continue;
        default:
          // Forward path to GoRouter (for webapp)
          yield Uri(
            path: uri.path,
            query: uri.query,
            fragment: uri.fragment,
          ).toString();
          continue;
      }
    } catch (e, s) {
      if (globals.scaffoldKey.currentState == null) {
        rethrow;
      }
      globals.scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Hiba egy link megnyitása közben'),
          showCloseIcon: true,
          duration: Duration(seconds: 10),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Részletek',
            onPressed: () {
              final NavigatorState? navigator =
                  globals.router.routerDelegate.navigatorKey.currentState;
              if (navigator != null) {
                showDialog(
                  context: navigator.context,
                  builder: (context) => ErrorDialog(
                    type: LErrorType.error,
                    title: 'Hiba egy link megnyitása közben',
                    icon: Icons.link_off,
                    message: e.toString(),
                    stack: s.toString(),
                  ),
                );
              }
            },
          ),
        ),
      );
    }
  }
}

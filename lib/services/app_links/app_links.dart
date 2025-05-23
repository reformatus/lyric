import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/main.dart';
import 'package:lyric/services/cue/write_cue.dart';
import 'package:lyric/ui/common/error/card.dart';
import 'package:lyric/ui/common/error/dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/cue.dart';

part 'app_links.g.dart';

final appLinksSingleton = AppLinks();

@Riverpod(keepAlive: true)
Stream<String> shouldNavigate(Ref ref) async* {
  await for (Uri uri in appLinksSingleton.uriLinkStream) {
    try {
      if (uri.scheme != 'lyric' && uri.authority != 'app.sofarkotta.hu') {
        continue;
      }
      switch (uri.pathSegments[0]) {
        case 'launch':
          switch (uri.pathSegments[1]) {
            case 'cueJson':
              String? jsonString = uri.queryParameters['data'];
              if (jsonString == null) continue;

              Cue cue = await insertCueFromJson(json: jsonDecode(jsonString));

              String? slideUuid = uri.queryParameters['slide'];

              yield Uri(
                pathSegments: ['cue', cue.uuid, 'edit'],
                queryParameters: Map.fromEntries([
                  if (slideUuid != null) MapEntry('slide', slideUuid),
                ]),
              ).toString();
            default:
              yield Uri(
                pathSegments: uri.pathSegments.skip(1),
                query: uri.query,
                fragment: uri.fragment,
              ).toString();
          }
          break;
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
      if (globals.scaffoldKey.currentState == null ||
          globals.scaffoldKey.currentContext == null) {
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
            onPressed:
                () => showAdaptiveDialog(
                  context: globals.scaffoldKey.currentContext!,
                  builder:
                      (context) => AdaptiveErrorDialog(
                        type: LErrorType.error,
                        title: 'Hiba egy link megnyitása közben',
                        icon: Icons.link_off,
                        message: e.toString(),
                        stack: s.toString(),
                      ),
                ),
          ),
        ),
      );
    }
  }
}

import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/main.dart';
import 'package:lyric/services/cue/write_cue.dart';
import 'package:lyric/ui/common/confirm_dialog.dart';
import 'package:lyric/ui/common/error/card.dart';
import 'package:lyric/ui/common/error/dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/cue.dart';
import '../cue/from_uuid.dart';

part 'app_links.g.dart';

final appLinksSingleton = AppLinks();

@Riverpod(keepAlive: true)
Stream<String> shouldNavigate(Ref ref) async* {
  await for (Uri uri in appLinksSingleton.uriLinkStream) {
    try {
      if (uri.scheme != constants.urlScheme &&
          uri.authority != constants.domain) {
        continue;
      }
      switch (uri.pathSegments[0]) {
        case 'launch':
          if (uri.pathSegments.length < 2) continue;
          switch (uri.pathSegments[1]) {
            // TODO factor out to a cue service or similar
            case 'cueJson':
              try {
                String? jsonString = uri.queryParameters['data'];
                if (jsonString == null) continue;
                Map json = jsonDecode(jsonString);

                Cue? existingCue = await dbWatchCueWithUuid(json['uuid']).first;
                Cue cue;
                if (existingCue == null) {
                  cue = await insertCueFromJson(json: jsonDecode(jsonString));
                } else {
                  cue = existingCue;
                  final NavigatorState? navigator =
                      globals.router.routerDelegate.navigatorKey.currentState;
                  if (navigator != null) {
                    await showConfirmDialog(
                      // ignore: use_build_context_synchronously
                      navigator.context,
                      title:
                          'A linkben megnyitott lista már létezik. Felülírod?',
                      actionLabel: 'Felülírás',
                      actionIcon: Icons.edit_note,
                      actionOnPressed: () async {
                        cue = await updateCueFromJson(json: json);
                      },
                    );
                  }
                }

                String? slideUuid = uri.queryParameters['slide'];

                yield Uri(
                  pathSegments: ['cue', cue.uuid, 'edit'],
                  queryParameters: Map.fromEntries([
                    if (slideUuid != null) MapEntry('slide', slideUuid),
                  ]),
                ).toString();
              } catch (e) {
                throw Exception('Hibás lista a linkben:\n$e');
              }
            default:
              yield Uri(
                pathSegments: uri.pathSegments.skip(1),
                query: uri.query,
                fragment: uri.fragment.isEmpty ? null : uri.fragment,
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
                showAdaptiveDialog(
                  context: navigator.context,
                  builder:
                      (context) => AdaptiveErrorDialog(
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

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../data/cue/cue.dart';
import '../../main.dart';
import '../../ui/common/confirm_dialog.dart';
import '../cue/from_uuid.dart';
import '../cue/write_cue.dart';
import 'compression.dart';

/// Result of importing a cue from a deep link
class CueImportResult {
  final Cue cue;
  final String? slideUuid;

  CueImportResult(this.cue, this.slideUuid);

  /// Returns the navigation path for this imported cue
  String getNavigationPath() {
    return Uri(
      pathSegments: ['cue', cue.uuid, 'edit'],
      queryParameters: Map.fromEntries([
        if (slideUuid != null) MapEntry('slide', slideUuid!),
      ]),
    ).toString();
  }
}

/// Imports a cue from compressed data in a deep link (cueData endpoint)
///
/// Handles:
/// - Decompression of MessagePack + gzip + base64url data
/// - Duplicate detection and user confirmation for overwrites
/// - Optional slide parameter for navigation
Future<CueImportResult> importCueFromCompressedData(
  String encodedData,
  Map<String, String> queryParameters,
) async {
  final json = decompressCueFromUrl(encodedData);
  final cue = await _importCueJson(json);
  final slideUuid = queryParameters['slide'];

  return CueImportResult(cue, slideUuid);
}

/// Imports a cue from plain JSON in a deep link (cueJson endpoint - backward compatible)
///
/// Handles:
/// - JSON decoding
/// - Duplicate detection and user confirmation for overwrites
/// - Optional slide parameter for navigation
Future<CueImportResult> importCueFromJson(
  String jsonString,
  Map<String, String> queryParameters,
) async {
  final json = jsonDecode(jsonString);
  final cue = await _importCueJson(json);
  final slideUuid = queryParameters['slide'];

  return CueImportResult(cue, slideUuid);
}

/// Common logic for importing a cue from JSON data
///
/// Checks if cue already exists and shows confirmation dialog if so.
/// Otherwise inserts as new cue.
Future<Cue> _importCueJson(Map json) async {
  Cue? existingCue = await dbWatchCueWithUuid(json['uuid']).first;

  if (existingCue == null) {
    // New cue - insert it
    return await insertCueFromJson(json: json);
  } else {
    // Existing cue - ask user if they want to overwrite
    final NavigatorState? navigator =
        globals.router.routerDelegate.navigatorKey.currentState;

    Cue cue = existingCue;

    if (navigator != null) {
      await showConfirmDialog(
        // ignore: use_build_context_synchronously
        navigator.context,
        title: 'A linkben megnyitott lista már létezik. Felülírod?',
        actionLabel: 'Felülírás',
        actionIcon: Icons.edit_note,
        actionOnPressed: () async {
          cue = await updateCueFromJson(json: json);
        },
      );
    }

    return cue;
  }
}

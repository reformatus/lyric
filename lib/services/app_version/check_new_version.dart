import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/log/logger.dart';
import '../../main.dart';

part 'check_new_version.g.dart';

typedef VersionInfo = ({
  String versionNumber,
  String releaseNotesMd,
  Uri releaseInfoLink,
});

@Riverpod(keepAlive: true)
Future<VersionInfo?> checkNewVersion(Ref ref) async {
  try {
    final latestRelease = (await globals.dio.get<Map<String, dynamic>>(
      '${constants.gitHubApiRoot}/releases/latest',
    )).data!;

    final latestVersion = (latestRelease['tag_name'] as String);

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final latest = latestVersion
        .split('+')
        .first
        .split('.')
        .map((e) => int.parse(e))
        .toList();
    final current = currentVersion.split('.').map((e) => int.parse(e)).toList();

    if (!latest.isNeverVersionThan(current)) return null;

    globals.scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Új verzió elérhető!'),
        backgroundColor: Colors.blue[700],
        showCloseIcon: true,
        duration: Duration(seconds: 10),
      ),
    );

    return (
      versionNumber: latestVersion,
      releaseNotesMd: latestRelease['body'] as String,
      releaseInfoLink: Uri.parse(latestRelease['html_url'] as String),
    );
  } catch (e, s) {
    log.warning("Couldn't check for new versions:", e, s);
    return null;
  }
}

extension VersionCompare on List<int> {
  /// Compare 3-number semantic versions
  bool isNeverVersionThan(List<int> other) {
    if (this[0] != other[0]) return this[0] > other[0];
    if (this[1] != other[1]) return this[1] > other[1];
    return this[2] > other[2];
  }
}

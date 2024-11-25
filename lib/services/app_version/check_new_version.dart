import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_new_version.g.dart';

typedef VersionInfo = ({String versionNumber, String releaseNotesMd, Uri releaseInfoLink, Uri downloadLink});

@Riverpod(keepAlive: true)
Future<VersionInfo?> checkNewVersion(Ref ref) async {
  try {
    final latestRelease =
        (await Dio().get<Map<String, dynamic>>('${globals.gitHubApiRoot}/releases/latest')).data!;

    final latestVersion = (latestRelease['tag_name'] as String);

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final latest = latestVersion.split('.').map((e) => int.parse(e)).toList();
    final current = currentVersion.split('.').map((e) => int.parse(e)).toList();

    if (current[0] >= latest[0] && current[1] >= latest[1] && current[2] >= latest[2]) return null;

    globals.scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text('Új verzió elérhető!'),
        backgroundColor: Colors.blue[700],
        showCloseIcon: true,
        duration: Duration(seconds: 10),
        action: SnackBarAction(
          label: 'Nézzük',
          onPressed: () => globals.router.go('/home'),
          backgroundColor: Colors.blue[900],
        )));

    return (
      versionNumber: latestVersion,
      releaseNotesMd: latestRelease['body'] as String,
      releaseInfoLink: Uri.parse(latestRelease['html_url'] as String),
      downloadLink: Uri.parse(latestRelease['assets'][0]['browser_download_url'])
    );
  } catch (e, s) {
    print("Couldn't check for new versions: $e\n$s");
    return null;
  }
}

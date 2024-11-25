import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

void showLyricAboutDialog(BuildContext context) async {
  final packageInfo = await PackageInfo.fromPlatform();
  showAboutDialog(
    // ignore: use_build_context_synchronously // this would only cause a problem if packageInto takes a long time to resolve
    context: context,
    applicationName: 'Lyric',
    applicationVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
    applicationIcon: Icon(Icons.music_note), // todo replace with app icon
    children: [
      Text('Telepítés forrása: ${packageInfo.installerStore ?? 'ismeretlen'}'),
    ],
  );
}

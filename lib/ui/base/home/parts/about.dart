import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/config.dart';
import 'feedback/send_mail.dart';

void showLyricAboutDialog(BuildContext context) async {
  final packageInfo = await PackageInfo.fromPlatform();
  showAboutDialog(
    // ignore: use_build_context_synchronously // this would only cause a problem if packageInto takes a long time to resolve
    context: context,
    applicationName: appConfig.appName,
    applicationVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
    applicationIcon: Icon(Icons.music_note), // todo replace with app icon
    children: [
      Text('Telepítés forrása: ${packageInfo.installerStore ?? 'ismeretlen'}'),
      Divider(),
      TextButton(
        child: Text('Hibajelentés'),
        onPressed: () => sendFeedbackEmail(),
      ),
      TextButton(
        child: Text('Weboldal'),
        onPressed: () => launchUrl(Uri.parse(appConfig.homepageRoot)),
      ),
      TextButton(
        child: Text('Powered by Lyric'),
        onPressed: () => launchUrl(Uri.parse(appConfig.gitHubRepo)),
      ),
      Divider(),
    ],
  );
}

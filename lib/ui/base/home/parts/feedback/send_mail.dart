import 'dart:convert';
import 'dart:io';

import 'package:mailto/mailto.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future launchFeedbackEmail({String? errorMessage, String? stackTrace}) async {
  JsonEncoder encoder = JsonEncoder.withIndent('  ', (o) {
    try {
      return o.toJson();
    } catch (_) {
      return o.toString();
    }
  });
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final String exceptionString = errorMessage == null
      ? ''
      : '''
[HIBA]
$errorMessage
${stackTrace?.split('\n').take(6).join('\n')}

''';

  Map? platformInfo;
  try {
    platformInfo = {
      //'environment': Platform.environment,
      'executable:': Platform.executable,
      'executableArguments': Platform.executableArguments,
      'localHostname': Platform.localHostname,
      'localeName': Platform.localeName,
      'numberOfProcessors': Platform.numberOfProcessors,
      'operatingSystem': Platform.operatingSystem,
      'operatingSystemVersion': Platform.operatingSystemVersion,
      'packageConfig': Platform.packageConfig,
      'resolvedExecutable': Platform.resolvedExecutable,
      'script': Platform.script,
      'dart-version': Platform.version,
    };
  } catch (_) {}

  final String subject = errorMessage == null ? 'Visszajelzés' : 'Hibajelentés: $errorMessage';

  Mailto mail = Mailto(
    to: ['lyric@reflabs.hu'],
    subject: '$subject - Lyric ${packageInfo.version}+${packageInfo.buildNumber}',
    body: '''
Írd le, mit tapasztaltál:




---------------
Az alábbi adatokat ne töröld ki, ha hibát jelentesz:
$exceptionString
[APP INFO]
${encoder.convert(packageInfo.data)}

[PLATFORM INFO]
${encoder.convert(platformInfo)}
''',
  );

  launchUrl(Uri.parse(mail.toString()));

  throw UnimplementedError();
}

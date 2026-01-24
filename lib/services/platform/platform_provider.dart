import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'platform_provider.g.dart';

class PlatformInfo {
  final bool isWeb;
  final bool isMobile;
  final bool isDesktop;

  const PlatformInfo({
    required this.isWeb,
    required this.isMobile,
    required this.isDesktop,
  });
}

@Riverpod(keepAlive: true)
PlatformInfo platformInfo(Ref ref) {
  const mobileTargets = {TargetPlatform.android, TargetPlatform.iOS};
  const desktopTargets = {
    TargetPlatform.macOS,
    TargetPlatform.windows,
    TargetPlatform.linux,
  };

  final isMobile = mobileTargets.contains(defaultTargetPlatform);
  final isDesktop = desktopTargets.contains(defaultTargetPlatform);

  return PlatformInfo(
    isWeb: kIsWeb,
    isMobile: isMobile,
    isDesktop: isDesktop,
  );
}

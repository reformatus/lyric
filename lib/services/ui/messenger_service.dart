import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messenger_service.g.dart';

class MessengerService {
  MessengerService({GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey})
    : scaffoldMessengerKey =
          scaffoldMessengerKey ?? GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  ScaffoldMessengerState? get state => scaffoldMessengerKey.currentState;
  BuildContext? get context => scaffoldMessengerKey.currentContext;

  void showSnackBar(SnackBar snackBar) {
    state?.showSnackBar(snackBar);
  }

  void clearBanners() {
    state?.clearMaterialBanners();
  }

  void showBanner(MaterialBanner banner) {
    state?.showMaterialBanner(banner);
  }

  void hideCurrentBanner() {
    state?.hideCurrentMaterialBanner();
  }
}

// Allow tests to replace this with a fake implementation.
MessengerService messengerService = MessengerService();

@Riverpod(keepAlive: true)
MessengerService messengerServiceProvider(Ref ref) => messengerService;

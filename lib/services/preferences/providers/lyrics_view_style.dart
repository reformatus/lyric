import '../preferences_parent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/log/logger.dart';

part 'lyrics_view_style.g.dart';

@Riverpod(keepAlive: true)
class LyricsViewStylePreferences extends _$LyricsViewStylePreferences {
  @override
  LyricsViewStylePreferencesClass build() {
    /*return GeneralPreferencesClass(
      appBrightness: ThemeMode.system,
      sheetBrightness: ThemeMode.light,
      oledBlackBackground: false,
    );*/
    throw UnimplementedError();
  }

  Future<void> loadFromDb() async {
    state = await state.getFromDb();
  }

  void go() async {
    ref.notifyListeners();
    try {
      await state.writeToDb();
    } catch (e, s) {
      log.severe('Nem sikerült a dalszövegstílus-beállítások mentése!', e, s);
    }
  }
}

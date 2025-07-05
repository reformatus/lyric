import 'package:lyric/data/preferences/classes/lyrics_view_style.dart';
import 'package:lyric/data/preferences/preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/log/logger.dart';

part 'preference.g.dart';

@Riverpod(keepAlive: true)
class GeneralPreferences extends _$GeneralPreferences {
  @override
  GeneralPreferencesClass build() {
    // Values here don't matter (defaults are in the fromJson factory)
    // far future todo: can this be removed and default values provided from the outside?
    return GeneralPreferencesClass(
      appBrightness: BrightnessSetting.light,
      sheetBrightness: BrightnessSetting.light,
    );
  }

  Future loadFromDb() async {
    state = await state.getFromDb();
  }

  void go() {
    state.writeToDb();
    ref.notifyListeners();
  }

  void setAppBrightness(BrightnessSetting newValue) {
    state.appBrightness = newValue;
    go();
  }

  void setSheetBrightness(BrightnessSetting newValue) {
    state.sheetBrightness = newValue;
    go();
  }
}

@Riverpod(keepAlive: true)
class SongPreferences extends _$SongPreferences {
  @override
  SongPreferencesClass build() {
    return SongPreferencesClass(
      lyricsViewStyle: LyricsViewStyle(
        lyricsSize: 0,
        chordsSize: 0,
        verseTagSize: 0,
      ),
      songViewOrder: {},
    );
  }

  Future loadFromDb() async {
    state = await state.getFromDb();
  }

  void go() {
    state.writeToDb();
    ref.notifyListeners();
  }

  void setValue(SongPreferencesClass newValue) {
    state = newValue;

    Future(() async {
      try {
        await state.writeToDb();
      } catch (e, s) {
        log.severe('Nem sikerült a beállítások mentése!', e, s);
      }
    });
  }
}

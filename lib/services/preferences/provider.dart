import 'package:flutter/material.dart';
import 'package:lyric/data/preferences/classes/lyrics_view_style.dart';
import 'package:lyric/data/preferences/preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/log/logger.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
class GeneralPreferences extends _$GeneralPreferences {
  @override
  GeneralPreferencesClass build() {
    // Values here don't matter (defaults are in the fromJson factory)
    // far future todo: can this be removed and default values provided from the outside?
    return GeneralPreferencesClass(
      appBrightness: ThemeMode.system,
      sheetBrightness: ThemeMode.light,
      oledBlackBackground: false,
    );
  }

  Future<void> loadFromDb() async {
    state = await state.getFromDb();
  }

  void go() {
    state.writeToDb();
    ref.notifyListeners();
  }

  void setAppBrightness(ThemeMode newValue) {
    state.appBrightness = newValue;
    go();
  }

  void setSheetBrightness(ThemeMode newValue) {
    state.sheetBrightness = newValue;
    go();
  }

  void setOledBlackBackground(bool newValue) {
    state.oledBlackBackground = newValue;
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

import 'dart:ui';

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
      appBrightness: Brightness.light,
      sheetBrightness: Brightness.light,
    );
  }

  Future loadFromDb() async {
    state = await state.getFromDb();
  }

  void setValue(GeneralPreferencesClass newValue) {
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

@Riverpod(keepAlive: true)
class SongPreferences extends _$SongPreferences {
  @override
  GeneralPreferencesClass build() {
    return GeneralPreferencesClass(
      appBrightness: Brightness.light,
      sheetBrightness: Brightness.light,
    );
  }

  Future loadFromDb() async {
    state = await state.getFromDb();
  }

  void setValue(GeneralPreferencesClass newValue) {
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

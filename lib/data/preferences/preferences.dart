import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:lyric/data/log/logger.dart';

import '../database.dart';
import 'classes/lyrics_view_style.dart';

sealed class PreferencesClass<T extends PreferencesClass<T>> {
  String key;
  PreferencesClass(this.key);

  /// Abstract method for subclasses to provide their fromJson factory
  T fromJson(Map<String, dynamic>? json);

  /// Initialize self from database
  Future<T> getFromDb() async {
    final json = await _getJsonFromDb();
    return fromJson(json);
  }

  Future<Map<String, dynamic>?> _getJsonFromDb() async {
    final json =
        (await (db.preferenceStorage.select()..where((p) => p.key.equals(key)))
                .getSingleOrNull())
            ?.value;
    return json;
  }

  Map<String, dynamic> toJson();

  /// Write self to database
  Future writeToDb() async {
    try {
      await db
          .into(db.preferenceStorage)
          .insert(
            PreferenceStorageCompanion(key: Value(key), value: Value(toJson())),
            mode: InsertMode.insertOrReplace,
          );
    } catch (e, s) {
      log.severe('Beállítások: Nem sikerült $key mentése!', e, s);
    }
  }
}

extension ThemeModeTitle on ThemeMode {
  String get title => switch (this) {
    ThemeMode.system => 'Rendszer',
    ThemeMode.light => 'Világos',
    ThemeMode.dark => 'Sötét',
  };
}

class GeneralPreferencesClass
    extends PreferencesClass<GeneralPreferencesClass> {
  ThemeMode appBrightness;
  ThemeMode sheetBrightness;
  bool oledBlackBackground;

  GeneralPreferencesClass({
    required this.appBrightness,
    required this.sheetBrightness,
    required this.oledBlackBackground,
  }) : super('generalPreferences');

  @override
  GeneralPreferencesClass fromJson(Map<String, dynamic>? json) {
    return GeneralPreferencesClass(
      appBrightness:
          ThemeMode.values[json?['appBrightness'] ?? ThemeMode.system.index],
      sheetBrightness:
          ThemeMode.values[json?['sheetBrightness'] ?? ThemeMode.light.index],
      oledBlackBackground: json?['oledBlackBackground'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'appBrightness': appBrightness.index,
      'sheetBrightness': sheetBrightness.index,
      'oledBlackBackground': oledBlackBackground,
    };
  }
}

class SongPreferencesClass extends PreferencesClass<SongPreferencesClass> {
  LyricsViewStyle lyricsViewStyle;
  Set songViewOrder;

  SongPreferencesClass({
    required this.lyricsViewStyle,
    required this.songViewOrder,
  }) : super('songPreferences');

  @override
  SongPreferencesClass fromJson(Map<String, dynamic>? json) {
    return SongPreferencesClass(
      lyricsViewStyle: LyricsViewStyle.fromJson(json?['lyricsViewStyle']),
      songViewOrder: Set.from(
        json?['songViewOrder'] ?? ['svg', 'pdf', 'chords', 'lyrics'],
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'lyricsViewStyle': lyricsViewStyle.toJson(),
      'songViewOrder': songViewOrder.toList(),
    };
  }
}

import 'dart:ui';

import 'package:drift/drift.dart';

import '../database.dart';
import 'classes/lyrics_view_style.dart';

sealed class PreferencesClass<T extends PreferencesClass<T>> {
  String key;
  PreferencesClass(this.key);

  /// Abstract method for subclasses to provide their fromJson factory
  T fromJson(Map<String, dynamic> json);

  /// Initialize self from database
  Future<T> getFromDb() async {
    final json = await _getJsonFromDb();
    return fromJson(json);
  }

  Future<Map<String, dynamic>> _getJsonFromDb() async {
    final json =
        (await (db.preferenceStorage.select()..where((p) => p.key.equals(key)))
                .getSingle())
            .value;
    return json;
  }

  Map<String, dynamic> toJson();

  /// Write self to database
  Future writeToDb() async {
    await ((db.update(db.preferenceStorage)..where((p) => p.key.equals(key)))
        .write(PreferenceStorageCompanion(value: Value(toJson()))));
  }
}

class GeneralPreferencesClass
    extends PreferencesClass<GeneralPreferencesClass> {
  Brightness appBrightness;
  Brightness sheetBrightness;

  GeneralPreferencesClass({
    required this.appBrightness,
    required this.sheetBrightness,
  }) : super('generalPreferences');

  @override
  GeneralPreferencesClass fromJson(Map<String, dynamic> json) {
    return GeneralPreferencesClass(
      appBrightness:
          Brightness.values[json['appBrightness'] ?? Brightness.light.index],
      sheetBrightness:
          Brightness.values[json['sheetBrightness'] ?? Brightness.light.index],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'appBrightness': appBrightness.index,
      'sheetBrightness': sheetBrightness.index,
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
  SongPreferencesClass fromJson(Map<String, dynamic> json) {
    return SongPreferencesClass(
      lyricsViewStyle: LyricsViewStyle.fromJson(json['lyricsViewStyle'] ?? {}),
      songViewOrder: Set.from(json['songViewOrder'] ?? []),
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

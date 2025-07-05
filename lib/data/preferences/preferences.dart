import 'dart:ui';

import 'package:drift/drift.dart';
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

enum BrightnessSetting {
  light('Világos'),
  dark('Sötét'),
  device('Eszköz');

  final String title;
  const BrightnessSetting(this.title);
}

class GeneralPreferencesClass
    extends PreferencesClass<GeneralPreferencesClass> {
  BrightnessSetting appBrightness;
  BrightnessSetting sheetBrightness;

  GeneralPreferencesClass({
    required this.appBrightness,
    required this.sheetBrightness,
  }) : super('generalPreferences');

  @override
  GeneralPreferencesClass fromJson(Map<String, dynamic>? json) {
    return GeneralPreferencesClass(
      appBrightness: BrightnessSetting
          .values[json?['appBrightness'] ?? BrightnessSetting.device.index],
      sheetBrightness: BrightnessSetting
          .values[json?['sheetBrightness'] ?? BrightnessSetting.light.index],
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

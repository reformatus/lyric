part of '../preferences_parent.dart';

extension ThemeModeTitle on ThemeMode {
  String get title => switch (this) {
    ThemeMode.system => 'Rendszer',
    ThemeMode.light => 'Világos',
    ThemeMode.dark => 'Sötét',
  };
}

class GeneralPreferencesClass
    extends PreferencesParentClass<GeneralPreferencesClass> {
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

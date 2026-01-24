part of '../preferences_parent.dart';

class LyricsViewStylePreferencesClass
    extends PreferencesParentClass<LyricsViewStylePreferencesClass> {
  double lyricsSize;
  double chordsSize;
  double verseTagSize;
  int verseCardColumnWidth;

  LyricsViewStylePreferencesClass({
    required this.lyricsSize,
    required this.chordsSize,
    required this.verseTagSize,
    required this.verseCardColumnWidth,
  }) : super('lyricsViewStyle');

  @override
  LyricsViewStylePreferencesClass fromJson(Map<String, dynamic>? json) {
    double defaultFontSize = 16;

    if (messengerService.context != null) {
      defaultFontSize =
          Theme.of(messengerService.context!).textTheme.bodyMedium?.fontSize ??
          20;
    }

    return LyricsViewStylePreferencesClass(
      lyricsSize: json?['lyricsSize'] ?? defaultFontSize,
      chordsSize: json?['chordsSize'] ?? defaultFontSize,
      verseTagSize: json?['verseTagSize'] ?? defaultFontSize,
      verseCardColumnWidth: json?['verseCardColumnWidth'] ?? 350,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'lyricsSize': lyricsSize,
      'chordsSize': chordsSize,
      'verseTagSize': verseTagSize,
      'verseCardColumnWidth': verseCardColumnWidth,
    };
  }
}

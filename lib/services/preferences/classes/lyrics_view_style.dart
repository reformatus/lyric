part of '../preferences_parent.dart';

class LyricsViewStylePreferencesClass
    extends PreferencesParentClass<LyricsViewStylePreferencesClass> {
  double lyricsSize;
  double chordsSize;
  double verseTagSize;

  LyricsViewStylePreferencesClass({
    required this.lyricsSize,
    required this.chordsSize,
    required this.verseTagSize,
  }) : super('lyricsViewStyle');

  @override
  LyricsViewStylePreferencesClass fromJson(Map<String, dynamic>? json) {
    return LyricsViewStylePreferencesClass(
      // TODO default values
      lyricsSize: json?['lyricsSize'] ?? 20,
      chordsSize: json?['chordsSize'] ?? 20,
      verseTagSize: json?['verseTagSize'] ?? 20,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'lyricsSize': lyricsSize,
      'chordsSize': chordsSize,
      'verseTagSize': verseTagSize,
    };
  }
}

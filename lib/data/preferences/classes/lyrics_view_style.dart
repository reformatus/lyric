class LyricsViewStyle {
  double lyricsSize;
  double chordsSize;
  double verseTagSize;

  LyricsViewStyle({
    required this.lyricsSize,
    required this.chordsSize,
    required this.verseTagSize,
  });

  factory LyricsViewStyle.fromJson(Map<String, dynamic>? json) {
    return LyricsViewStyle(
      // TODO default values
      lyricsSize: json?['lyricsSize'] ?? 20,
      chordsSize: json?['chordsSize'] ?? 20,
      verseTagSize: json?['verseTagSize'] ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lyricsSize': lyricsSize,
      'chordsSize': chordsSize,
      'verseTagSize': verseTagSize,
    };
  }
}

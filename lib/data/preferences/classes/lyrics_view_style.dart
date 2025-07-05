class LyricsViewStyle {
  double lyricsSize;
  double chordsSize;
  double verseTagSize;

  LyricsViewStyle({
    required this.lyricsSize,
    required this.chordsSize,
    required this.verseTagSize,
  });

  factory LyricsViewStyle.fromJson(Map<String, dynamic> json) {
    return LyricsViewStyle(
      lyricsSize: json['lyricsSize'],
      chordsSize: json['chordsSize'],
      verseTagSize: json['verseTagSize'],
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

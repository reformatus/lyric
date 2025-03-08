import 'package:lyric/data/song/song.dart';

extension PropertyUtils on Song {
  bool get hasSvg => contentMap['svg']?.isNotEmpty ?? false;

  bool get hasPdf => contentMap['pdf']?.isNotEmpty ?? false;
  
  // TODO figure out api for non-opensong chord notation
  bool get hasLyrics => contentMap['opensong']?.isNotEmpty ?? false;
  
  // TODO figure out api for non-opensong chord notation
  /// Matches for a `.` after a new line (for OpenSong chord formatting)
  bool get hasChords => hasLyrics ? RegExp(r'\n\.').hasMatch(contentMap['opensong']?? "") : false;
}

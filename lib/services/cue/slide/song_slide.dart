import 'package:drift/drift.dart';
import 'package:lyric/ui/song/state.dart';

import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';
import '../../../data/database.dart';
import '../../../data/song/song.dart';
import '../../../data/song/transpose.dart';

Future addSongSlideToCueForSong({
  required Cue cue,
  required Song song,
  required SongViewType viewType,
  SongTranspose? transpose,
}) async {
  // necessary to add the song's latest hashcode

  (db.update(db.cues)..where((c) => c.uuid.equals(cue.uuid))).write(
    CuesCompanion(
      content: Value([
        ...cue.content,
        SongSlide(song, cue, viewType: viewType, transpose: transpose).toJson(),
      ]),
    ),
  );
}

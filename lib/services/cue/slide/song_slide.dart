import 'package:drift/drift.dart';

import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';
import '../../../data/database.dart';

Future addSongSlideToCueForSongWithUuid({required Cue cue, required String songUuid}) async {
  // necessary to add the song's latest hashcode
  final song = await (db.select(db.songs)..where((s) => s.uuid.equals(songUuid))).getSingle();

  (db.update(db.cues)..where((c) => c.uuid.equals(cue.uuid))).write(
    CuesCompanion(
      content: Value(
        [
          ...cue.content,
          SongSlide(song).toJson(),
        ],
      ),
    ),
  );
}

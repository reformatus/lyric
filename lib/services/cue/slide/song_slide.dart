import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/cue/cue.dart';
import '../../../data/cue/slide.dart';
import '../../../data/database.dart';
import '../../../data/song/song.dart';
import '../../../data/song/transpose.dart';
import '../../../ui/song/state.dart';

Future addNewSlideOfSongToCue({
  required Cue cue,
  required Song song,
  required SongViewType viewType,
  SongTranspose? transpose,
  String? comment, // TODO implement comment UI
}) async {
  var slideUuid = const Uuid().v4();

  // necessary to add the song's latest hashcode
  (db.update(db.cues)..where((c) => c.uuid.equals(cue.uuid))).write(
    CuesCompanion(
      content: Value([
        ...cue.content,
        SongSlide(
          slideUuid,
          song,
          cue,
          comment,
          viewType: viewType,
          transpose: transpose,
        ).toJson(),
      ]),
    ),
  );
}

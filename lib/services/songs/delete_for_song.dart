import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../data/song/song.dart';

/// Deletes all assets associated with a given song.
Future<int> deleteAssetsForSong(Song song) async {
  return await db.assets.deleteWhere((a) => a.songUuid.equals(song.uuid));
}

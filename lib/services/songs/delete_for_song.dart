import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../data/song/song.dart';

Future<int> deleteAssetsForSong(Song song) async {
  return await db.assets.deleteWhere((a) => a.songUuid.equals(song.uuid));
}

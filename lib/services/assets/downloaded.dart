import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../data/song/song.dart';

final JoinedSelectStatement<$AssetsTable, Asset> downloadedAssetsSubquery =
    db.selectOnly(db.assets)
      ..addColumns([
        db.assets.fieldName.groupConcat(distinct: true, separator: ','),
      ])
      ..where(db.assets.songUuid.equalsExp(db.songs.uuid));

Future<List<String>> downloadedAssetsForSong(Song song) async {
  final query = db.selectOnly(db.assets)
    ..addColumns([db.assets.fieldName])
    ..where(db.assets.songUuid.equals(song.uuid));

  final result = await query.get();

  return result
      .map((row) => row.read(db.assets.fieldName))
      .where((fieldName) => fieldName != null)
      .cast<String>()
      .toList();
}

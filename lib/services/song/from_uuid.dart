import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/song/song.dart';

part 'from_uuid.g.dart';

// todo make simple wrappers like this for all db access to make migration from drift possible if necessary
@riverpod
Future<Song> songFromUuid(Ref ref, String uuid) async {
  Song? songOrNull = await dbSongFromUuid(uuid);
  if (songOrNull == null) {
    throw Exception("Úgy tűnik, ez a dal nincs a táradban: $uuid");
  } else {
    return songOrNull;
  }
}

Future<Song?> dbSongFromUuid(String uuid) async {
  return (await (db.songs.select()..where((s) => s.uuid.equals(uuid)))
      .getSingleOrNull());
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/song/song.dart';
import '../../ui/base/songs/filter/state.dart';

part 'filter.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> selectableValuesForFilterableField(
    SelectableValuesForFilterableFieldRef ref, String field, FieldType fieldType) async {
  final allSongs = await ref.watch(allSongsProvider.future);
  Set<String> values = {};

  for (Song song in allSongs) {
    if (fieldType.commaDividedValues) {
      values.addAll(song.content[field]?.split(',') ?? []);
    } else {
      values.add(song.content[field] ?? "");
    }
  }

  values.remove("");
  return values.toList();
}

// todo write test
@riverpod
Future<Map<String, ({FieldType type, int count})>> existingSearchableFields(
    ExistingSearchableFieldsRef ref) async {
  Map<String, ({FieldType type, int count})> fields = {};

  final allSongs = Stream.fromIterable(await ref.watch(allSongsProvider.future));

  await for (var song in allSongs) {
    for (var field in song.content.keys) {
      if ((FieldType.fromString(songFieldsMap[field]?['type'] ?? "")?.isSearchable ?? false) &&
          song.content[field]! != "") {
        if (!fields.keys.any((k) => k == field)) {
          // first time we see this field
          fields[field] = (type: FieldType.fromString(songFieldsMap[field]!['type'])!, count: 1);
        } else {
          // increment count by reassigning the record for the entry
          fields[field] = (type: fields[field]!.type, count: fields[field]!.count + 1);
        }
      }
    }
  }

  return fields;
}

// todo write test
@riverpod
Future<Map<String, ({FieldType type, int count})>> existingFilterableFields(
    ExistingFilterableFieldsRef ref) async {
  Map<String, ({FieldType type, int count})> fields = {};

  final allSongs = Stream.fromIterable(await ref.watch(allSongsProvider.future));

  await for (var song in allSongs) {
    for (var field in song.content.keys) {
      if ((FieldType.fromString(songFieldsMap[field]?['type'] ?? "")?.isFilterable ?? false) &&
          song.content[field]! != "") {
        if (!fields.keys.any((k) => k == field)) {
          // first time we see this field
          fields[field] = (type: FieldType.fromString(songFieldsMap[field]!['type'])!, count: 1);
        } else {
          // increment count by reassigning the record for the entry
          fields[field] = (type: fields[field]!.type, count: fields[field]!.count + 1);
        }
      }
    }
  }

  return fields;
}

@Riverpod(keepAlive: true)
Stream<List<Song>> allSongs(AllSongsRef ref) {
  return db.select(db.songs).watch();
}

@riverpod
Stream<List<Song>> filteredSongList(FilteredSongListRef ref) {
  // todo actually apply filters

  return db.select(db.songs).watch();
}

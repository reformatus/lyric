import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/bank/bank.dart';
import '../../../../data/song/song.dart';
import 'state.dart';

part 'execute.g.dart';

// todo make part of bank
// todo write test
@riverpod
Map<String, ({FieldType type, int count})> existingSearchableFields(ExistingSearchableFieldsRef ref) {
  Map<String, ({FieldType type, int count})> fields = {};

  final allSongs = ref.watch(allSongsProvider);

  for (var song in allSongs) {
    for (var field in song.content.keys) {
      if (FieldType.fromString(songFieldsMap[field]?['type'] ?? "")?.isSearchable ?? false) {
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

// todo make part of bank
// todo write test
@riverpod
Map<String, ({FieldType type, int count})> existingFilterableFields(ExistingFilterableFieldsRef ref) {
  Map<String, ({FieldType type, int count})> fields = {};

  final allSongs = ref.watch(allSongsProvider);

  for (var song in allSongs) {
    for (var field in song.content.keys) {
      if (FieldType.fromString(songFieldsMap[field]?['type'] ?? "")?.isFilterable ?? false) {
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

@riverpod
Future<List<Song>> filteredSongList(FilteredSongListRef ref) async {
  final state = ref.watch(filterStateProvider);
  final allSongs = ref.watch(allSongsProvider);

  // todo actually apply filters

  //await Future.delayed(const Duration(seconds: 1));
  //throw UnimplementedError();

  return allSongs.toList();
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/database.dart';
import '../../data/song/song.dart';
import '../../ui/base/songs/filter/state.dart';

part 'filter.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> selectableValuesForFilterableField(
    SelectableValuesForFilterableFieldRef ref, String field, FieldType fieldType) async {
  final allSongs = Stream.fromIterable(await ref.watch(allSongsProvider.future));
  Set<String> values = {};

  await for (Song song in allSongs) {
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
// todo merge with existingFilterableFields
@Riverpod(keepAlive: true)
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
@Riverpod(keepAlive: true)
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

const snippetTags = (start: '<?', end: '?>');

@Riverpod(keepAlive: true)
Stream<List<SongResult>> filteredSongs(FilteredSongsRef ref) {
  final String searchString = sanitize(ref.watch(searchStringStateProvider));
  // ignore: unused_local_variable // todo remove
  final List<String> searchFields = ref.watch(searchFieldsStateProvider);
  // ignore: unused_local_variable // todo remove
  final Map<String, List<String>> filters = ref.watch(filterStateProvider);

  if (searchString.isEmpty) {
    return db.select(db.songs).watch().map((songs) {
      return songs.map((song) {
        return SongResult(song: song);
      }).toList();
    });
  } else if (searchString.length < 3) {
    return Stream.value([]);
  } else {
    final matchStream = db.song_fulltext_search(searchString).watch();
    final songStream = db.select(db.songs).watch();

    // if both streams have returned at least one list, combine and return an always updating result
    return CombineLatestStream.combine2(matchStream, songStream, (matches, songs) {
      return matches.map((match) {
        final song = songs.firstWhere((song) => match.uuid == song.uuid); // todo optimize maybe?
        return SongResult(song: song, match: match);
      }).toList();
    });
  }
}

class SongResult {
  final Song song;
  final SongFulltextSearchResult? match;

  SongResult({
    required this.song,
    this.match,
  });
}

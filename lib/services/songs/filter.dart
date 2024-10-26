import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/song/song.dart';
import '../../ui/base/songs/filter/state.dart';

part 'filter.g.dart';

// far future todo: implement dynamic fts table generation based on bank data and dynamic selectable fts columns
const List<String> fullTextSearchFields = [
  'title',
  'lyrics',
  'composer',
  'poet',
  'translator',
];

// todo write test
@Riverpod(keepAlive: true)
Future<Map<String, ({FieldType type, int count})>> existingFilterableFields(Ref ref) async {
  Map<String, ({FieldType type, int count})> fields = {};

  final allSongs = Stream.fromIterable(await ref.watch(allSongsProvider.future));

  await for (var song in allSongs) {
    for (var field in song.contentMap.keys) {
      if ((FieldType.fromString(songFieldsMap[field]?['type'] ?? "")?.isFilterable ?? false) &&
          song.contentMap[field]! != "") {
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
Future<List<String>> selectableValuesForFilterableField(Ref ref, String field, FieldType fieldType) async {
  final allSongs = Stream.fromIterable(await ref.watch(allSongsProvider.future));
  Set<String> values = {};

  await for (Song song in allSongs) {
    if (fieldType.commaDividedValues) {
      values.addAll(song.contentMap[field]?.split(',') ?? []);
    } else {
      values.add(song.contentMap[field] ?? "");
    }
  }

  values.remove("");
  return values.toList();
}

@Riverpod(keepAlive: true)
Stream<List<Song>> allSongs(Ref ref) {
  return db.select(db.songs).watch();
}

const snippetTags = (start: '<?', end: '?>');

@Riverpod(keepAlive: true)
Stream<List<SongResult>> filteredSongs(Ref ref) {
  final String searchString = sanitize(ref.watch(searchStringStateProvider));
  // ignore: unused_local_variable // todo implement
  final List<String> searchFields = ref.watch(searchFieldsStateProvider);
  final Map<String, List<String>> filters = ref.watch(filterStateProvider);

  Expression<bool> filterExpression(SongsFts songsFts) => Expression.and(
        filters.entries.map(
          (entry) {
            final fieldData = songsFts.contentMap.jsonExtract<String>('\$.${entry.key}');
            return Expression.or(
              entry.value.map((value) => fieldData.like('%$value%')),
            );
          },
        ),
      );

  if (searchString.isEmpty) {
    return ((db.select(db.songsFts)..where((songsFts) => filterExpression(songsFts))).watch()).map(
      (songsFtList) => songsFtList.map((songsFt) => SongResult(songsFt: songsFt)).toList(),
    );
  } else {
    return (db.song_fulltext_search(searchString, (songsFts) => filterExpression(songsFts)).watch()).map(
      (matchList) => matchList.map((match) => SongResult(match: match)).toList(),
    );
  }
}

class SongResult {
  final SongsFt? songsFt;
  final SongFulltextSearchResult? match;

  SongResult({
    this.songsFt,
    this.match,
  }) {
    assert(songsFt != null || match != null,
        'Either SongFt (normally) or SongFulltextSearchResult (when using FTS search) should be returned!');
  }
}

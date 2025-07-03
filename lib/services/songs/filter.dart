// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/base/songs/widgets/filter/types/bank/state.dart';
import 'package:lyric/ui/base/songs/widgets/filter/types/key/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/song/song.dart';
import '../../ui/base/songs/widgets/filter/types/field_type.dart';
import '../../ui/base/songs/widgets/filter/types/multiselect-tags/state.dart';
import '../../ui/base/songs/widgets/filter/types/search/state.dart';

part 'filter.g.dart';

// far future todo: implement dynamic fts table generation based on bank data and dynamic selectable fts columns
const List<String> fullTextSearchFields = [
  'title',
  'opensong',
  'composer',
  'lyricist',
  'translator',
];

// todo write test
@Riverpod(keepAlive: true)
Future<Map<String, ({FieldType type, int count})>> existingFilterableFields(
  Ref ref,
) async {
  Map<String, ({FieldType type, int count})> fields = {};

  final allSongs = Stream.fromIterable(
    await ref.watch(allSongsProvider.future),
  );

  await for (var song in allSongs) {
    for (var field in song.contentMap.keys) {
      if ((FieldType.fromString(
                songFieldsMap[field]?['type'] ?? "",
              )?.isFilterable ??
              false) &&
          song.contentMap[field]! != "") {
        if (!fields.keys.any((k) => k == field)) {
          // first time we see this field
          fields[field] = (
            type: FieldType.fromString(songFieldsMap[field]!['type'])!,
            count: 1,
          );
        } else {
          // increment count by reassigning the record for the entry
          fields[field] = (
            type: fields[field]!.type,
            count: fields[field]!.count + 1,
          );
        }
      }
    }
  }

  return fields;
}

@Riverpod(keepAlive: true)
Future<List<String>> selectableValuesForFilterableField(
  Ref ref,
  String field,
  FieldType fieldType,
) async {
  final allSongs = Stream.fromIterable(
    await ref.watch(allSongsProvider.future),
  );
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
  final List<String> searchFields = ref.watch(searchFieldsStateProvider);
  final Map<String, List<String>> filters = ref.watch(
    multiselectTagsFilterStateProvider,
  );
  final KeyFilters keyFilters = ref.watch(keyFilterStateProvider);
  final Set<String> bankFilters = ref.watch(banksFilterStateProvider);

  String ftsMatchString = '{${searchFields.join(' ')}} : $searchString';

  Expression<bool> filterExpression(Songs songs) {
    return Expression.and(
      filters.entries
          .map((entry) {
            final fieldData = songs.contentMap.jsonExtract<String>(
              '\$.${entry.key}',
            );
            return Expression.or(
              entry.value.map((value) => fieldData.like('%$value%')),
            );
          })
          .followedBy([
            Expression.or([
              if (keyFilters.pitches.isNotEmpty || keyFilters.modes.isNotEmpty)
                Expression.and([
                  if (keyFilters.pitches.isNotEmpty)
                    Expression.or(
                      keyFilters.pitches.map(
                        (e) => songs.keyField.like('$e-%'),
                      ),
                    ),
                  if (keyFilters.modes.isNotEmpty)
                    Expression.or(
                      keyFilters.modes.map((e) => songs.keyField.like('%-$e')),
                    ),
                ]),
              if (keyFilters.keys.isNotEmpty)
                Expression.or(
                  keyFilters.keys.map(
                    (e) => songs.keyField.equals(e.toString()),
                  ),
                ),
            ], ifEmpty: Constant(true)),
            if (bankFilters.isNotEmpty)
              Expression.or(bankFilters.map((b) => songs.sourceBank.equals(b))),
          ]),
    );
  }

  final downloadedAssetsSubquery = db.selectOnly(db.assets)
    ..addColumns([
      db.assets.fieldName.groupConcat(distinct: true, separator: ','),
    ])
    ..where(db.assets.songUuid.equalsExp(db.songs.uuid));

  if (searchString.isEmpty) {
    return ((db.select(db.songs).addColumns([
      subqueryExpression(downloadedAssetsSubquery),
    ])..where(filterExpression(db.songs))).watch()).map(
      (resultList) => resultList
          .map(
            (result) => SongResult(
              result.readTable(db.songs),
              downloadedAssets:
                  (result.rawData.readNullableWithType(
                    DriftSqlType.string,
                    'c0',
                  ))?.split(',') ??
                  [],
            ),
          )
          .toList(),
    );
  } else {
    return db
        .songFulltextSearch(
          (_, _) => subqueryExpression(downloadedAssetsSubquery),
          ftsMatchString,
          (_, songs) => filterExpression(songs),
        )
        .watch()
        .map(
          (results) => results
              .map(
                (result) => SongResult(
                  result.song,
                  result: result,
                  downloadedAssets: result.assets?.split(',') ?? [],
                ),
              )
              .toList(),
        );
  }
}

class SongResult {
  final Song song;
  final List<String> downloadedAssets;
  final SongFulltextSearchResult? result;

  SongResult(this.song, {required this.downloadedAssets, this.result});
}

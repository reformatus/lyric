import 'package:drift/drift.dart';

// todo invalidate asset if underlying song is updated, to trigger re-download
@TableIndex(name: 'asset_source_url', columns: {#sourceUrl}, unique: true)
class Assets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get songUuid => text()();
  TextColumn get sourceUrl => text()();
  TextColumn get fieldName => text()();
  BlobColumn get content => blob()();
}

// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

import 'package:sofar/data/database.dart';

/// Migration tests are tagged so they can be excluded until migrations are implemented.
/// Run with: flutter test --exclude-tags=migration
@Tags(['migration'])
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = LyricDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // The following template shows how to write tests ensuring your migrations
  // preserve existing data.
  // Testing this can be useful for migrations that change existing columns
  // (e.g. by alterating their type or constraints). Migrations that only add
  // tables or columns typically don't need these advanced tests. For more
  // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // TODO: This generated template shows how these tests could be written. Adopt
  // it to your own needs when testing migrations with data integrity.
  test('migration from v1 to v2 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    // TODO: Fill these lists
    final oldBanksData = <v1.BanksData>[];
    final expectedNewBanksData = <v2.BanksData>[];

    final oldSongsData = <v1.SongsData>[];
    final expectedNewSongsData = <v2.SongsData>[];

    final oldAssetsData = <v1.AssetsData>[];
    final expectedNewAssetsData = <v2.AssetsData>[];

    final oldCuesData = <v1.CuesData>[];
    final expectedNewCuesData = <v2.CuesData>[];

    final oldPreferenceStorageData = <v1.PreferenceStorageData>[];
    final expectedNewPreferenceStorageData = <v2.PreferenceStorageData>[];

    final oldSongsFtsData = <v1.SongsFtsData>[];
    final expectedNewSongsFtsData = <v2.SongsFtsData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: LyricDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.banks, oldBanksData);
        batch.insertAll(oldDb.songs, oldSongsData);
        batch.insertAll(oldDb.assets, oldAssetsData);
        batch.insertAll(oldDb.cues, oldCuesData);
        batch.insertAll(oldDb.preferenceStorage, oldPreferenceStorageData);
        batch.insertAll(oldDb.songsFts, oldSongsFtsData);
      },
      validateItems: (newDb) async {
        expect(expectedNewBanksData, await newDb.select(newDb.banks).get());
        expect(expectedNewSongsData, await newDb.select(newDb.songs).get());
        expect(expectedNewAssetsData, await newDb.select(newDb.assets).get());
        expect(expectedNewCuesData, await newDb.select(newDb.cues).get());
        expect(
          expectedNewPreferenceStorageData,
          await newDb.select(newDb.preferenceStorage).get(),
        );
        expect(
          expectedNewSongsFtsData,
          await newDb.select(newDb.songsFts).get(),
        );
      },
    );
  });
}

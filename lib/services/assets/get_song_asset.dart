import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/song/song.dart';
import '../../main.dart';
import '../bank/bank_of_song.dart';

part 'get_song_asset.g.dart';

typedef AssetResult = ({double progress, Uint8List? data});

@riverpod
Stream<AssetResult> getSongAsset(
  Ref ref,
  Song song,
  String fieldName,
  //int fieldIndex, // TODO handle multi-file fields?
) {
  final controller = StreamController<AssetResult>();

  () async {
    final bank = await ref.watch(bankOfSongProvider(song).future);
    final String sourceUrl = bank.baseUrl
        .resolve(song.contentMap[fieldName]!)
        .toString();

    final asset =
        await (db.assets.select()..where((a) => a.sourceUrl.equals(sourceUrl)))
            .getSingleOrNull();

    if (asset != null) {
      controller.add((progress: 1.0, data: asset.content));
      await controller.close();
    } else {
      // Download the asset with progress updates
      try {
        final response = await globals.dio.get<List<int>>(
          sourceUrl,
          options: Options(
            responseType: ResponseType.bytes,
            sendTimeout: Duration(seconds: 3),
            receiveTimeout: Duration(seconds: 10),
          ),
          onReceiveProgress: (received, total) {
            if (total != -1) {
              final progress = (received / total).clamp(0.0, 1.0);
              controller.add((progress: progress, data: null));
            }
          },
        );

        // Save the downloaded asset to the database
        await db.assets.insert().insert(
          AssetsCompanion(
            songUuid: Value(song.uuid),
            fieldName: Value(fieldName),
            sourceUrl: Value(sourceUrl),
            content: Value(Uint8List.fromList(response.data!)),
          ),
        );

        // Add the final value
        controller.add((
          progress: 1.0,
          data: Uint8List.fromList(response.data!),
        ));
      } catch (e) {
        controller.addError(e);
      } finally {
        await controller.close();
      }
    }
  }();

  return controller.stream;
}

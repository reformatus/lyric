import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/song/song.dart';
import '../../../services/assets/get_song_asset.dart';
import '../../../services/bank/bank_of_song.dart';
import '../../common/error.dart';

class SheetView extends ConsumerWidget {
  const SheetView(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bank = ref.watch(bankOfSongProvider(song));
    switch (bank) {
      case AsyncLoading():
        return Center(child: CircularProgressIndicator(value: 0.5));
      case AsyncError(:final error, :final stackTrace):
        return Center(
          child: LErrorCard(
            type: LErrorType.error,
            title: 'Nem találjuk az énekhez tartozó énektárat',
            message: error.toString(),
            stack: stackTrace.toString(),
            icon: Icons.error,
          ),
        );
      case AsyncValue(:final value!):
        final svgAsset = ref.watch(
          getSongAssetProvider(
            song,
            'svg',
            value.baseUrl.resolve(song.contentMap['svg']!).toString(),
          ),
        );

        switch (svgAsset) {
          case AsyncError(:final error, :final stackTrace):
            return Center(
              child: LErrorCard(
                type: LErrorType.error,
                title: 'Nem sikerült betölteni a kottaképet.',
                message: error.toString(),
                stack: stackTrace.toString(),
                icon: Icons.error,
              ),
            );
          case AsyncData(value: final assetResult):
            if (assetResult.data != null) {
              return InteractiveViewer(
                maxScale: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.memory(
                    assetResult.data!,
                    // todo make this color configurable
                    /*colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      BlendMode.src,
                    ),*/
                  ),
                ),
              );
            } else {
              print('Progress: ${assetResult.progress}');
              return CircularProgressIndicator(value: assetResult.progress);
            }
          default:
            return Center(child: CircularProgressIndicator(value: 0.8));
        }
    }
  }
}

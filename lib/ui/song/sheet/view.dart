import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyric/ui/song/state.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../data/song/song.dart';
import '../../../services/assets/get_song_asset.dart';
import '../../common/error.dart';

class SheetView extends ConsumerWidget {
  const SheetView.svg(this.song, {super.key}) : _viewType = SongViewType.svg;
  const SheetView.pdf(this.song, {super.key}) : _viewType = SongViewType.pdf;

  final SongViewType _viewType;
  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    assert(_viewType != SongViewType.lyrics);

    final asset = ref.watch(
      getSongAssetProvider(song, switch (_viewType) {
        SongViewType.svg => 'svg',
        SongViewType.pdf || _ => 'pdf',
      }),
    );

    switch (asset) {
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
          switch (_viewType) {
            case SongViewType.svg:
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
            case SongViewType.pdf || _:
              // TODO build out a proper pdf viewer
              return PdfViewer.data(assetResult.data!, sourceName: song.uuid);
          }
        } else {
          print('Progress: ${assetResult.progress}');
          return CircularProgressIndicator(value: assetResult.progress);
        }
      default:
        return Center(child: CircularProgressIndicator(value: 0.8));
    }
  }
}

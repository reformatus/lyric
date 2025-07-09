import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../data/song/song.dart';
import '../../../main.dart';
import '../../../services/assets/get_song_asset.dart';
import '../../../services/preferences/providers/general.dart';
import '../../common/error/card.dart';
import '../state.dart';

class SheetView extends ConsumerWidget {
  const SheetView.svg(this.song, {super.key}) : _viewType = SongViewType.svg;
  const SheetView.pdf(this.song, {super.key}) : _viewType = SongViewType.pdf;

  final SongViewType _viewType;
  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    assert(
      _viewType != SongViewType.lyrics && _viewType != SongViewType.chords,
    );

    final generalPrefs = ref.watch(generalPreferencesProvider);
    final Brightness sheetBrightness = switch (generalPrefs.sheetBrightness) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => MediaQuery.platformBrightnessOf(context),
    };

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
              return Theme(
                data: ThemeData.from(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: constants.seedColor,
                    primary: constants.primaryColor,
                    brightness: sheetBrightness,
                    surface: sheetBrightness == Brightness.dark
                        ? Colors.black
                        : null,
                  ),
                ),
                child: Builder(
                  builder: (context) {
                    return Container(
                      color: sheetBrightness == Brightness.light
                          ? Theme.of(context).colorScheme.onPrimary
                          : generalPrefs.oledBlackBackground
                          ? Colors.black
                          : Theme.of(context).colorScheme.surface,
                      child: InteractiveViewer(
                        maxScale: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SvgPicture.memory(
                            assetResult.data!,
                            colorFilter: sheetBrightness == Brightness.dark
                                ? ColorFilter.mode(
                                    Theme.of(context).colorScheme.onSurface,
                                    BlendMode.srcIn,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            case SongViewType.pdf || _:
              return PdfViewer.data(
                assetResult.data!,
                sourceName: song.uuid,
                params: PdfViewerParams(
                  backgroundColor: Theme.of(context).canvasColor,
                  loadingBannerBuilder: (_, _, _) =>
                      Center(child: CircularProgressIndicator()),
                  pageDropShadow: BoxShadow(
                    color: Theme.of(context).shadowColor.withAlpha(30),
                    blurRadius: 30,
                  ),
                  scrollByMouseWheel: null,
                ),
              );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(value: assetResult.progress),
          );
        }
      default:
        return Center(child: CircularProgressIndicator(value: 0.8));
    }
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cue/slide.dart';
import '../../data/song/extensions.dart';
import '../../data/song/song.dart';
import '../../services/assets/downloaded.dart';
import '../../services/connectivity/provider.dart';
import '../../services/preferences/providers/song_view_order.dart';

part 'state.g.dart';

enum SongViewType {
  svg('svg', requiresAsset: true),
  pdf('pdf', requiresAsset: true),
  lyrics('lyrics'),
  chords('chords');

  final String type;
  final bool requiresAsset;

  const SongViewType(this.type, {this.requiresAsset = false});
  factory SongViewType.fromString(String type) {
    return SongViewType.values.firstWhere((e) => e.type == type);
  }
}

@Riverpod(keepAlive: true)
class ViewTypeFor extends _$ViewTypeFor {
  @override
  Future<SongViewType> build(Song song, SongSlide? songSlide) async {
    final songViewOrder = (ref.watch(
      songViewOrderPreferencesProvider,
    )).songViewOrder;

    if (ref.read(connectionProvider) == ConnectionType.offline) {
      List<String> downloadedAssets = await downloadedAssetsForSong(song);

      return songViewOrder.firstWhere(
        (v) =>
            (song.availableViews.contains(v.name)) &&
            (!v.requiresAsset ||
                (v.requiresAsset && downloadedAssets.contains(v.name))),
      );
    } else {
      return songViewOrder.firstWhere(
        (v) => song.availableViews.contains(v.name),
      );
    }
  }

  void setTo(SongViewType newValue) {
    state = AsyncValue.data(newValue);
    if (songSlide != null) {
      songSlide!.viewType = newValue;
    }
  }
}

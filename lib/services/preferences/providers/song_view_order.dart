import '../preferences_parent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/log/logger.dart';

part 'song_view_order.g.dart';

@Riverpod(keepAlive: true)
class SongViewOrderPreferences extends _$SongViewOrderPreferences {
  @override
  SongViewOrderPreferencesClass build() {
    return SongViewOrderPreferencesClass(songViewOrder: []);
  }

  Future<void> loadFromDb() async {
    state = await state.getFromDb();
  }

  void go() async {
    ref.notifyListeners();
    try {
      await state.writeToDb();
    } catch (e, s) {
      log.severe('Nem sikerült az alapértelmezett nézet mentése!', e, s);
    }
  }
}

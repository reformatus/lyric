import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/database.dart';
import 'package:lyric/data/song/song.dart';
import 'package:lyric/ui/base/songs/filter/key/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter.g.dart';

typedef KeyFilterSelectable = ({String label, Function(bool) onSelected, bool selected, bool addingKey});

@Riverpod(keepAlive: true)
Stream<List<KeyFilterSelectable>> selectablePitches(Ref ref) {
  final state = ref.watch(keyFilterStateProvider);
  if (state.modes.length == 1 && state.pitches.isEmpty) {
    return db.selectDistinctPitches(state.modes.first).watch().map((pitches) {
      List<KeyFilterSelectable> selectables = [];
      for (var e in pitches) {
        final key = KeyField(e, state.modes.first);
        if (state.keys.contains(key)) continue;
        selectables.add((
          label: key.toString(),
          onSelected: (v) => ref.read(keyFilterStateProvider.notifier).setKeyTo(key, v),
          selected: state.keys.contains(key),
          addingKey: true,
        ));
      }
      return selectables;
    });
  } else {
    return db.selectDistinctPitches('%').watch().map((pitches) {
      return pitches
          .map(
            (e) => (
              label: e,
              onSelected: (v) => ref.read(keyFilterStateProvider.notifier).setPitchTo(e, v),
              selected: state.pitches.contains(e),
              addingKey: false,
            ),
          )
          .toList();
    });
  }
}

@Riverpod(keepAlive: true)
Stream<List<KeyFilterSelectable>> selectableModes(Ref ref) {
  final state = ref.watch(keyFilterStateProvider);
  if (state.pitches.length == 1 && state.modes.isEmpty) {
    return db.selectDistinctModes(state.pitches.first).watch().map((modes) {
      List<KeyFilterSelectable> selectables = [];
      for (var e in modes) {
        final key = KeyField(state.pitches.first, e);
        if (state.keys.contains(key)) continue;
        selectables.add((
          label: key.toString(),
          onSelected: (v) => ref.read(keyFilterStateProvider.notifier).setKeyTo(key, v),
          selected: state.keys.contains(key),
          addingKey: true,
        ));
      }
      return selectables;
    });
  } else {
    return db.selectDistinctModes('%').watch().map((modes) {
      return modes
          .map(
            (e) => (
              label: e,
              onSelected: (v) => ref.read(keyFilterStateProvider.notifier).setModeTo(e, v),
              selected: state.modes.contains(e),
              addingKey: false,
            ),
          )
          .toList();
    });
  }
}

import 'package:chord_transposer/chord_transposer.dart';
import '../../data/song/song.dart';

String? getTransposedChord(String? original, String? fromKey, int semitones) {
  if (original == null) return null;
  try {
    var transposer = ChordTransposer(
      notation: NoteNotation.germanWithAccidentals,
    );
    return transposer.chordUp(
      chord: original,
      fromKey: fromKey,
      semitones: semitones,
    );
  } catch (e) {
    return '?';
  }
}

// TODO hungarian notation? Handle non-base input pitch?
KeyField getTransposedKey(KeyField key, int semitones) {
  var transposer = ChordTransposer(notation: NoteNotation.german);
  return KeyField(
    transposer.chordUp(
      chord: key.pitch,
      fromKey: key.pitch,
      semitones: semitones,
    ),
    key.mode,
  );
}

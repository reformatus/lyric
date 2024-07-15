const Map<String, String> textSearchFields = {
  'title': 'Cím',
  'titleOriginal': 'Cím (eredeti)',
  'firstLine': 'Kezdősor',
  'composer': 'Dalszerző',
  'poet': 'Szövegíró',
  'translator': 'Fordította',
  'bibleRef': 'Igeszakasz',
  'refSongbook': 'Református Énekeskönyv',
};
const List<Map<String, dynamic>> filterFields = [
  {
    'id': 'language',
    'name': 'Nyelv',
    'type': 'multiselect_chips',
    'values': [
      'magyar',
      'angol',
      'német',
      'francia',
      'héber',
      'ír',
      'cigány',
      'egyéb',
    ]
  },
  {
    'id': 'tempo',
    'name': 'Tempó',
    'type': 'multiselect_chips',
    'values': [
      'lassú',
      'közepes',
      'gyors',
      'változó',
    ]
  },
  {
    'id': 'ambitus',
    'name': 'Hangterjedelem',
    'type': 'multiselect_chips',
    'values': [
      'egy oktáv',
      'másfél oktáv',
      'két oktáv',
    ]
  },
  {
    'id': 'pitchNote',
    'name': 'Hangnem',
    'type': 'pitch',
    'values': [
      'C',
      'C#/D♭',
      'D',
      'D#/E♭',
      'E',
      'F',
      'F#/G♭',
      'G',
      'G#/A♭',
      'A',
      'A#/B',
    ]
  },
  {
    'id': 'pitchScale',
    'name': 'Hangsor',
    'type': 'pitch',
    'values': [
      'dúr',
      'moll',
      'dór',
      'fríg',
      'líd',
      'mixolíd',
      'lokriszi',
    ]
  },
  {
    'id': 'genre',
    'name': 'Stílus / műfaj',
    'type': 'multiselect_chips',
    'values': [
      'angolszász',
      'himnusz',
      'folk - magyar',
      'folk - ír',
      'folk - cigány',
      'spirituálé/gospel',
      'meditatív',
      'gyerekdal',
      'egyéb',
    ]
  },
  {
    'id': 'contentTags',
    'name': 'Tartalomcímkék',
    'type': 'multiselect_search',
    'values': [
      'Atya',
      'áldás',
      'bátorítás',
      'békesség',
      'bizalom Istenben',
      'bűnbánat',
      'elhívás-küldetés',
      'evangélium',
      'feltámadás',
      'gondviselés',
      'győzelem',
      'hálaadás',
      'hitvallás',
      'hívás',
      'imádat',
      'Isten tulajdonságai',
      'Jézus',
      'kegyelem',
      'közbenjárás',
      'megtérés',
      'mennyország',
      'Mindenható',
      'oltalom',
      'örvendezés',
      'passió',
      'reménység',
      'szabadítás',
      'Szentírás',
      'Szentlélek',
      'szentség',
      'szeretet',
      'Szentháromság',
      'teremtett világ',
      'várakozás Istenre',
      'vezetés',
      'visszajövetel',
    ]
  },
  {
    'id': 'holiday',
    'name': 'Ünnep',
    'type': 'multiselect_chips',
    'values': [
      'böjt',
      'húsvét',
      'pünkösd',
      'reformáció',
      'advent',
      'karácsony',
      'egyéb',
    ]
  },
  {
    'id': 'sofar',
    'name': 'Először szerepelt Sófárban',
    'type': 'muliselect_search',
    'values': 'self_discover',
  }
];

class FilterState {
  String searchString = "";
  List<String> activeTextSearchFields = [];
  Map<String, List<String>> activeFilterFields = {};
}

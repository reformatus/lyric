const List<Map<String, dynamic>> songFields = [
  {
    'id': 'title',
    'name': 'Cím',
    'type': 'searchable',
  },
  {
    'id': 'titleOriginal',
    'name': 'Cím (eredeti)',
    'type': 'searchable',
  },
  {
    'id': 'firstLine',
    'name': 'Kezdősor',
    'type': 'searchable',
  },
  {
    'id': 'composer',
    'name': 'Dalszerző',
    'type': 'searchable',
  },
  {
    'id': 'poet',
    'name': 'Szövegíró',
    'type': 'searchable',
  },
  {
    'id': 'translator',
    'name': 'Fordította',
    'type': 'searchable',
  },
  {
    'id': 'bibleRef',
    'name': 'Igeszakasz',
    'type': 'searchable',
  },
  {
    'id': 'refSongbook',
    'name': 'Református Énekeskönyv',
    'type': 'searchable',
  },
  {
    'id': 'language',
    'name': 'Nyelv',
    'type': 'filterable_multiselect_chips',
  },
  {
    'id': 'tempo',
    'name': 'Tempó',
    'type': 'filterable_multiselect_chips',
  },
  {
    'id': 'ambitus',
    'name': 'Hangterjedelem',
    'type': 'filterable_multiselect_chips',
  },
  {
    'id': 'pitch',
    'name': 'Hangnem',
    'type': 'pitch',
  },
  {
    'id': 'genre',
    'name': 'Stílus / műfaj',
    'type': 'filterable_multiselect_chips',
  },
  {
    'id': 'contentTags',
    'name': 'Tartalomcímkék',
    'type': 'filterable_multiselect_search',
  },
  {
    'id': 'holiday',
    'name': 'Ünnep',
    'type': 'filterable_multiselect_chips',
  },
  {
    'id': 'sofar',
    'name': 'Először szerepelt Sófáron',
    'type': 'filterable_multiselect_search',
  }
];

class FilterState {
  String searchString = "";
  List<String> activeTextSearchFields = [];
  Map<String, List<String>> activeFilterFields = {};
}

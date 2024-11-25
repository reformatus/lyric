import 'package:flutter/material.dart';
import 'package:lyric/services/songs/filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state.g.dart';

// far future todo: make this plugin extendable / bank provider extendable

// let plugins provide filter ui and logic
const Map<String, Map<String, dynamic>> songFieldsMap = {
  'title': {
    'title_hu': 'Cím',
    'type': 'searchable',
    'icon': Icons.text_fields,
  },
  'title_original': {
    'title_hu': 'Cím (eredeti)',
    'type': 'searchable',
    'icon': Icons.wrap_text,
  },
  'first_line': {
    'title_hu': 'Kezdősor',
    'type': 'searchable',
    'icon': Icons.short_text,
  },
  'lyrics': {
    'title_hu': 'Dalszöveg',
    'type': 'searchable',
    'icon': Icons.text_snippet,
  },
  'composer': {
    'title_hu': 'Dalszerző',
    'type': 'searchable',
    'icon': Icons.music_note,
  },
  'lyricist': {
    'title_hu': 'Szövegíró',
    'type': 'searchable',
    'icon': Icons.edit,
  },
  'translator': {
    'title_hu': 'Fordította',
    'type': 'searchable',
    'icon': Icons.translate,
  },
  'bible_ref': {
    'title_hu': 'Igeszakasz',
    'type': 'searchable',
    'icon': Icons.book,
  },
  'ref_songbook': {
    'title_hu': 'Református Énekeskönyv',
    'type': 'searchable',
    'icon': Icons.menu_book,
  },
  'language': {
    'title_hu': 'Eredeti nyelv',
    'type': 'filterable_multiselect_tags',
    'icon': Icons.language,
  },
  'tempo': {
    'title_hu': 'Tempó',
    'type': 'filterable_multiselect',
    'icon': Icons.speed,
  },
  'ambitus': {
    'title_hu': 'Hangterjedelem',
    'type': 'filterable_multiselect',
    'icon': Icons.height,
  },
  'key': {
    'title_hu': 'Hangnem',
    'type': 'filterable_key',
    'icon': Icons.music_note,
  },
  'genre': {
    'title_hu': 'Stílus / műfaj',
    'type': 'filterable_multiselect_tags',
    'icon': Icons.style,
  },
  'content_tags': {
    'title_hu': 'Tartalomcímkék',
    'type': 'filterable_multiselect_tags',
    'icon': Icons.label_sharp,
  },
  'holiday': {
    'title_hu': 'Ünnep',
    'type': 'filterable_multiselect_tags',
    'icon': Icons.celebration,
  },
  'sofar': {
    'title_hu': 'Először szerepelt Sófáron',
    'type': 'filterable_multiselect_tags',
    'icon': Icons.calendar_month,
  },
};

@Riverpod(keepAlive: true)
class SearchFieldsState extends _$SearchFieldsState {
  @override
  List<String> build() {
    return [...fullTextSearchFields];
  }

  void addSearchField(String field) {
    if (!state.contains(field)) {
      state.add(field);
      ref.notifyListeners();
    }
  }

  void removeSearchField(String field) {
    if (state.length < 2) return; // Make sure at least one column stays selected
    state.remove(field);
    ref.notifyListeners();
  }
}

@Riverpod(keepAlive: true)
class SearchStringState extends _$SearchStringState {
  @override
  String build() {
    return "";
  }

  void set(String value) {
    state = value;
  }

  void clear() {
    state = "";
  }
}

@Riverpod(keepAlive: true)
class MultiselectTagsFilterState extends _$MultiselectTagsFilterState {
  @override
  Map<String, List<String>> build() {
    return {};
  }

  @override
  String toString() {
    return state.values.map((e) => e.join(' ')).join(' | ');
  }

  void addFilter(String field, String value) {
    if (state.containsKey(field)) {
      state[field]!.add(value);
    } else {
      state[field] = [value];
    }
    ref.notifyListeners();
  }

  void removeFilter(String field, String value) {
    if (state.containsKey(field)) {
      state[field]!.remove(value);
      if (state[field]!.isEmpty) {
        state.remove(field);
      }
      ref.notifyListeners();
    }
  }

  void toggleFilter(String field, String value) {
    if (state.containsKey(field) && state[field]!.contains(value)) {
      removeFilter(field, value);
    } else {
      addFilter(field, value);
    }
    ref.notifyListeners();
  }

  void resetFilterField(String field) {
    state.remove(field);
    state = Map.fromEntries(state.entries.skipWhile((e) => e.key == field));
  }

  void resetAllFilters() {
    state = {};
  }
}

// @project2
enum FieldType {
  multiselect("filterable_multiselect", isFilterable: true),
  multiselectTags("filterable_multiselect_tags", isFilterable: true, commaDividedValues: true),
  key("filterable_key", isFilterable: true),
  searchable("searchable", isSearchable: true);

  const FieldType(this.name,
      {this.isSearchable = false, this.isFilterable = false, this.commaDividedValues = false});
  final String name;
  final bool isSearchable;
  final bool isFilterable;
  final bool commaDividedValues;

  // Static map for fast lookup
  static final Map<String, FieldType> _typeMap = {for (var field in FieldType.values) field.name: field};

  static FieldType? fromString(String value) => _typeMap[value];
}

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state.g.dart';

// far future todo: make this plugin extendable / bank provider extendable
// let plugins provide filter ui and logic
const Map<String, Map<String, dynamic>> songFieldsMap = {
  'title': {
    'name': 'Cím',
    'type': 'searchable',
    'icon': Icons.text_fields,
  },
  'titleOriginal': {
    'name': 'Cím (eredeti)',
    'type': 'searchable',
    'icon': Icons.wrap_text,
  },
  'firstLine': {
    'name': 'Kezdősor',
    'type': 'searchable',
    'icon': Icons.short_text,
  },
  'composer': {
    'name': 'Dalszerző',
    'type': 'searchable',
    'icon': Icons.music_note,
  },
  'poet': {
    'name': 'Szövegíró',
    'type': 'searchable',
    'icon': Icons.edit,
  },
  'translator': {
    'name': 'Fordította',
    'type': 'searchable',
    'icon': Icons.translate,
  },
  'bibleRef': {
    'name': 'Igeszakasz',
    'type': 'searchable',
    'icon': Icons.book,
  },
  'refSongbook': {
    'name': 'Református Énekeskönyv',
    'type': 'searchable',
    'icon': Icons.menu_book,
  },
  'language': {
    'name': 'Nyelv',
    'type': 'filterable_multiselect_chips',
    'icon': Icons.language,
  },
  'tempo': {
    'name': 'Tempó',
    'type': 'filterable_multiselect_chips',
    'icon': Icons.speed,
  },
  'ambitus': {
    'name': 'Hangterjedelem',
    'type': 'filterable_multiselect_chips',
    'icon': Icons.height,
  },
  'pitch': {
    'name': 'Hangnem',
    'type': 'filterable_pitch',
    'icon': Icons.music_note,
  },
  'genre': {
    'name': 'Stílus / műfaj',
    'type': 'filterable_multiselect_chips',
    'icon': Icons.style,
  },
  'contentTags': {
    'name': 'Tartalomcímkék',
    'type': 'filterable_multiselect_search',
    'icon': Icons.label_sharp,
  },
  'holiday': {
    'name': 'Ünnep',
    'type': 'filterable_multiselect_chips',
    'icon': Icons.celebration,
  },
  'sofar': {
    'name': 'Először szerepelt Sófáron',
    'type': 'filterable_multiselect_search',
    'icon': Icons.calendar_month,
  },
};

@riverpod
class SearchFieldsState extends _$SearchFieldsState {
  @override
  List<String> build() {
    return songFieldsMap.entries
        .where((e) => FieldType.fromString(e.value['type'])?.isSearchable ?? false)
        .map((e) => e.key)
        .toList();
  }

  void addSearchField(String field) {
    if (!state.contains(field)) {
      state.add(field);
    }
  }

  void removeSearchField(String field) {
    state.remove(field);
  }
}

@riverpod
class SearchStringState extends _$SearchStringState {
  @override
  String build() {
    return "";
  }

  void setSearchString(String value) {
    state = value;
  }

  void clearSearchString() {
    state = "";
  }
}

@riverpod
class FilterState extends _$FilterState {
  @override
  Map<String, List<String>> build() {
    return {};
  }

  void addFilter(String field, String value) {
    if (state.containsKey(field)) {
      state[field]!.add(value);
    } else {
      state[field] = [value];
    }
  }

  void removeFilter(String field, String value) {
    if (state.containsKey(field)) {
      state[field]!.remove(value);
      if (state[field]!.isEmpty) {
        state.remove(field);
      }
    }
  }

  void resetFilterField(String field) {
    state.remove(field);
  }

  void resetAllFilters() {
    state.clear();
  }
}

// @project2
enum FieldType {
  multiselectChips("filterable_multiselect_chips", isFilterable: true),
  multiselectSearch("filterable_multiselect_search", isFilterable: true),
  pitch("filterable_pitch", isFilterable: true),
  searchable("searchable", isSearchable: true);

  const FieldType(this.type, {this.isSearchable = false, this.isFilterable = false});
  final String type;
  final bool isSearchable;
  final bool isFilterable;

  // Static map for fast lookup
  static final Map<String, FieldType> _typeMap = {for (var field in FieldType.values) field.type: field};

  static FieldType? fromString(String value) => _typeMap[value];
}

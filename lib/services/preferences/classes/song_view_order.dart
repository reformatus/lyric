part of '../preferences_parent.dart';

class SongViewOrderPreferencesClass
    extends PreferencesParentClass<SongViewOrderPreferencesClass> {
  List<SongViewType> songViewOrder;

  SongViewOrderPreferencesClass({required this.songViewOrder})
    : super('songViewOrderPreferences');

  @override
  SongViewOrderPreferencesClass fromJson(Map<String, dynamic>? json) {
    return SongViewOrderPreferencesClass(
      songViewOrder:
          ((json?['songViewOrder'] ?? ['svg', 'chords', 'pdf', 'lyrics'])
                  as List<String>)
              .map<SongViewType>(
                (String typeString) => SongViewType.fromString(typeString),
              )
              .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'songViewOrder': songViewOrder.map((viewType) => viewType.type).toList(),
    };
  }
}

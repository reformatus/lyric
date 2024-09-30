const List<String> mandatoryFields = ['title', 'lyrics'];

class Song {
  final String uuid;
  Map<String, String> content;
  String? userNote;

  factory Song.fromJson(Map<String, dynamic> json) {
    try {
      if (!mandatoryFields.every((field) => json.containsKey(field))) {
        throw Exception(
            'Missing mandatory fields in: ${json['title']} (${json['uuid']})');
      }

      return Song(
        json['uuid'],
        json.map((key, value) => MapEntry(key, value.toString())),
      );
    } catch (e) {
      throw Exception(
          'Invalid song data in: ${json['title']} (${json['uuid']})\nError: $e');
    }
  }

  Song(this.uuid, this.content);
}

class PitchField {}

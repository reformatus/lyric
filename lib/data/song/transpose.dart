class SongTranspose {
  int semitones;
  int capo;

  int get finalTransposeBy => semitones - capo;
  bool get isNotEmpty => semitones != 0 || capo != 0;

  SongTranspose({this.semitones = 0, this.capo = 0});

  Map<String, dynamic> toJson() {
    return {'semitones': semitones, 'capo': capo};
  }

  factory SongTranspose.fromJson(Map<String, dynamic> json) {
    return SongTranspose(semitones: json['semitones'], capo: json['capo']);
  }
}

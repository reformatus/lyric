class SongTranspose {
  int semitones;
  int capo;

  int get finalTransposeBy => semitones - capo;

  SongTranspose({required this.semitones, required this.capo});

  Map<String, dynamic> toJson() {
    return {'semitones': semitones, 'capo': capo};
  }

  factory SongTranspose.fromJson(Map<String, dynamic> json) {
    return SongTranspose(semitones: ['semitones'] as int, capo: json['capo'] as int);
  }
}

import 'dart:convert';

import '../../main.dart';

import '../../data/cue/cue.dart';
import '../../data/song/song.dart';

String getShareableLinkFor<T>(T item) {
  if (item is Song) {
    return Uri(
      scheme: 'https',
      host: constants.domain,
      pathSegments: ['launch', 'song', item.uuid],
    ).toString();
  } else if (item is Cue) {
    return Uri(
      scheme: 'https',
      host: constants.domain,
      pathSegments: ['launch', 'cueJson'],
      queryParameters: {'data': jsonEncode(item.toJson())},
    ).toString();
  } else {
    throw Exception('${item.runtimeType} típusú elem nem megosztható!');
  }
}

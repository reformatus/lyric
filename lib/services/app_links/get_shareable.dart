import '../../config/config.dart';

import '../../data/cue/cue.dart';
import '../../data/song/song.dart';
import '../cue/compression.dart';

Uri getShareableLinkFor<T>(T item) {
  if (item is Song) {
    return Uri(
      scheme: 'https',
      host: appConfig.domain,
      pathSegments: ['launch', 'song', item.uuid],
    );
  } else if (item is Cue) {
    return Uri(
      scheme: 'https',
      host: appConfig.domain,
      pathSegments: ['launch', 'cueData'],
      queryParameters: {'data': compressCueForUrl(item.toJson())},
    );
  } else {
    throw Exception('${item.runtimeType} típusú elem nem megosztható!');
  }
}

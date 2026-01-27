import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofar/data/bank/bank.dart';
import 'package:sofar/services/bank/bank_api.dart';
import 'package:sofar/services/http/dio_provider.dart';

import '../harness/test_harness.dart';

void main() {
  group('BankApi', () {
    late TestHarness harness;
    late RecordingHttpAdapter recorder;

    setUp(() {
      harness = TestHarness();
      recorder = RecordingHttpAdapter(
        responseBuilder: (options) {
          // Return different responses based on the request path
          if (options.path.contains('/songs')) {
            return ResponseBody.fromString(
              '[{"uuid":"song-1","title":"Test Song"}]',
              200,
            );
          }
          if (options.path.contains('/song/')) {
            return ResponseBody.fromString(
              '[{"uuid":"song-1","title":"&quot;Test&quot;","opensong":"&amp;verse","key":"C-major","composer":"&apos;Composer&apos;"}]',
              200,
            );
          }
          if (options.path.contains('/about')) {
            return ResponseBody.fromString(
              '{"lastUpdated":"2025-01-01T00:00:00Z"}',
              200,
            );
          }
          return ResponseBody.fromString('{}', 200);
        },
      );
      harness.mockDio.httpClientAdapter = recorder;
    });

    tearDown(() {
      harness.dispose();
    });

    test('dioProvider returns mock dio from harness', () {
      final dio = harness.container.read(dioProvider);
      expect(dio, isA<Dio>());
    });

    test('requests are recorded for assertions', () async {
      final dio = harness.container.read(dioProvider);
      await dio.get('https://example.com/api/songs');

      expect(recorder.requests, hasLength(1));
      expect(recorder.requests.first.path, contains('/songs'));
    });

    test('unescapes html entities in song payloads', () async {
      final bankApi = BankApi(harness.mockDio);
      final songs = await bankApi.getDetailsForSongs(
        Bank(
          1,
          'bank-1',
          null,
          null,
          'Test Bank',
          null,
          null,
          null,
          null,
          Uri.parse('https://example.com/api'),
          1,
          1,
          false,
          const {},
          true,
          false,
          null,
        ),
        ['song-1'],
      );

      expect(songs, hasLength(1));
      expect(songs.first.title, '"Test"');
      expect(songs.first.opensong, '&verse');
      expect(songs.first.composer, "'Composer'");
      expect(songs.first.contentMap['title'], '"Test"');
      expect(songs.first.contentMap['opensong'], '&verse');
    });
  });
}

import 'package:dio/dio.dart';

/// A fake Dio adapter that returns predictable responses for testing.
///
/// Usage:
/// ```dart
/// final mockDio = createMockDio();
/// mockDio.httpClientAdapter = MockHttpAdapter(
///   onRequest: (options) => ResponseBody.fromString('{"ok":true}', 200),
/// );
/// ```
class MockHttpAdapter implements HttpClientAdapter {
  MockHttpAdapter({this.onRequest});

  final ResponseBody Function(RequestOptions options)? onRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (onRequest != null) {
      return onRequest!(options);
    }
    return ResponseBody.fromString('{}', 200);
  }

  @override
  void close({bool force = false}) {}
}

/// Creates a Dio instance configured for testing.
///
/// By default returns empty JSON responses. Attach a [MockHttpAdapter]
/// for custom responses.
Dio createMockDio() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: Duration(milliseconds: 100),
      receiveTimeout: Duration(milliseconds: 100),
    ),
  );
  dio.httpClientAdapter = MockHttpAdapter();
  return dio;
}

/// Records all requests made through the Dio instance for assertions.
class RecordingHttpAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];
  final ResponseBody Function(RequestOptions options)? responseBuilder;

  RecordingHttpAdapter({this.responseBuilder});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (responseBuilder != null) {
      return responseBuilder!(options);
    }
    return ResponseBody.fromString('{}', 200);
  }

  @override
  void close({bool force = false}) {}

  void clear() => requests.clear();
}

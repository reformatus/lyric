import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

Dio appDio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 10),
  ),
);

@Riverpod(keepAlive: true)
Dio dio(Ref ref) => appDio;

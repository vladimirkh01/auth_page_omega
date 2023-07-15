import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioSettings {
  Dio dio = Dio();

  DioSettings() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://158.160.14.209',
        contentType: 'application/json',
        responseType: ResponseType.plain,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 7),
      ),
    );

    final interceptors = dio.interceptors;
    interceptors.clear();

    final logInterceptor = LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    );

    final headerInterceptors = QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        return handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
    );

    interceptors.addAll([
      if (kDebugMode) logInterceptor,
      headerInterceptors,
    ]);
  }
}

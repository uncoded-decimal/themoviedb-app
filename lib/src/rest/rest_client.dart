import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wework_challenge/src/app/misc/api_constants.dart';
import 'package:wework_challenge/src/rest/logging_interceptor.dart';

class RestClient {
  static Dio _prepareClient() {
    final dioOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Authorization": "Bearer $apiToken"},
    );
    final dio = Dio(dioOptions);
    dio.interceptors.add(LoggingIngterceptor());
    return dio;
  }

  static Future<Map<String, dynamic>?> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final client = _prepareClient();
      final response = await client.get(
        path,
        queryParameters: queryParams,
      );
      return response.data;
    } catch (e) {
      log('RESTLog :: GET operation failed with exception - $e');
      return null;
    }
  }
}

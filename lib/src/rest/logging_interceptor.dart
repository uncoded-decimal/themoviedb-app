import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingIngterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    StringBuffer logBuffer = StringBuffer();
    logBuffer
      ..writeln("==============API Call=============")
      ..writeln("| BaseUrl: ${response.requestOptions.baseUrl}")
      ..writeln("| Path: ${response.requestOptions.path}")
      ..writeln("|")
      ..writeln("| HEADERS");
    response.requestOptions.headers.forEach((key, value) {
      logBuffer.writeln("| $key : $value");
    });
    logBuffer
      ..writeln("|")
      ..writeln("| RESPONSE:")
      ..writeln("| Status Code: ${response.statusCode}")
      ..writeln("| Body: ${response.data}")
      ..writeln("==================================");
    log(logBuffer.toString());
    super.onResponse(response, handler);
  }
}

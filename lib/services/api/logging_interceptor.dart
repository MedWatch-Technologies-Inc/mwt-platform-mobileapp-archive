import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:health_gauge/services/logging/logging_service.dart';

class CustomLoggingInterceptor extends Interceptor {

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    return handler.next(options);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // _logPrint(_LoggingModel(
    //     uri: response.requestOptions.uri.toString(),
    //     response: response.toString()));
    return handler.resolve(response);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handle) async {
    _LoggingModel model;
    if (err.response != null) {
      model = _LoggingModel(
        uri: err.response!.requestOptions.uri.toString(),
        statusCode: err.response!.statusCode?.toString(),
        response: err.response.toString(),
        error: '$err',
      );
    } else {
      model = _LoggingModel(
        uri: err.requestOptions.uri.toString(),
        error: '$err',
      );
    }
    _logPrint(model);
    handle.next(err);
  }

  void _logPrint(_LoggingModel logs) {
    try {
      var message = json.encode(logs.toJson());
      LoggingService().logMessage(message);
    } on Exception {
      var mess =
          '{\"uri\": \"${logs.uri}\", \"statusCode\": \"${logs.statusCode}\", \"response\": \"${logs.response}\", \"error\":\"${logs.error}\"}';
      LoggingService().logMessage(mess);
    }
  }
}

class _LoggingModel {
  String? uri;
  String? statusCode;
  String? error;
  String? response;

  _LoggingModel({
    this.uri,
    this.statusCode,
    this.error,
    this.response,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uri'] = uri;
    data['statusCode'] = statusCode;
    data['error'] = error;
    data['response'] = response != null ? json.decode(response!) : null;
    return data;
  }
}

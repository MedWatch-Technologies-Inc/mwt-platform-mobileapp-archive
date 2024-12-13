import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import 'api_analytics_interceptor.dart';
import 'logging_interceptor.dart';

class ServiceManager {
  static ServiceManager? _serviceManager;

  // App BaseUrl
  String? _baseUrl;

  //Is Debug Mode
  late bool _isDebug;

  late bool _logApiFailure;
  late bool _logApiCallWithBasicData;

  // ignore: prefer_final_fields
  HashMap<String, String> _defaultHeaders = HashMap();

  ServiceManager(this._baseUrl, this._isDebug, this._logApiFailure,
      this._logApiCallWithBasicData, this._defaultHeaders);

  static void init(
      {@required String? baseUrl,
      @required bool? isDebug,
      bool logApiFailure = false,
      bool logApiCallWithBasicData = false,
      HashMap<String, String>? defaultHeaders}) {
    _serviceManager = ServiceManager._instance(
        baseUrl: baseUrl,
        isDebug: isDebug ?? false,
        logApiCallWithBasicData: logApiCallWithBasicData,
        logApiFailure: logApiFailure,
        defaultHeaders: defaultHeaders);
  }

  ServiceManager._instance(
      {@required String? baseUrl,
      bool isDebug = false,
      bool logApiFailure = false,
      bool logApiCallWithBasicData = false,
      HashMap<String, String>? defaultHeaders}) {
    _baseUrl = baseUrl;
    _isDebug = isDebug;
    _logApiFailure = logApiFailure;
    _logApiCallWithBasicData = logApiCallWithBasicData;
    if (defaultHeaders != null && defaultHeaders.isNotEmpty) {
      _defaultHeaders.addAll(defaultHeaders);
    }
  }

  static ServiceManager get() {
    if (_serviceManager == null) {

      throw Exception('Method not initialised');
    }
    return _serviceManager!;
  }

  Dio getDioClient({
    String? baseUrl,
    HashMap<String, String>? moreHeaders,
  }) {
    final dio = Dio();

    var hashMap = HashMap<String, String>();
    hashMap['Content-Type'] = 'application/json; charset=utf-8';
    hashMap['Accept'] = 'application/json; charset=utf-8';

    dio
      ..options.baseUrl = _baseUrl ?? ''
      ..options.headers.addAll(hashMap);
    if (baseUrl != null && baseUrl.trim().isNotEmpty) {
      dio.options.baseUrl = baseUrl.trim();
    }
    if (_defaultHeaders.isNotEmpty) {
      dio.options.headers.addAll(_defaultHeaders);
    }
    if (moreHeaders != null && moreHeaders.isNotEmpty) {
      dio.options.headers.addAll(moreHeaders);
    }

    if (_isDebug) {
      dio.interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
          () {
        var client = HttpClient();
        //create a SecurityContext that doesn't trust the OS's certificates:
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
        return client;
      };
    } else {
      dio.interceptors.add(CustomLoggingInterceptor());
    }
    
    if(_logApiCallWithBasicData || _logApiFailure) {
      dio.interceptors.add(ApiAnalyticsInterceptor(
        logApiCallWithBasicData: _logApiCallWithBasicData,
        logApiFailure: _logApiFailure,
        request: true,
        error: true,
      ));
    }
    return dio;
  }

  Dio getDioSSLClient({
    required String pem,
    String? baseUrl,
    HashMap<String, String>? moreHeaders,
  }) {
    final dio = getDioClient(baseUrl: baseUrl, moreHeaders: moreHeaders);

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
        () {
      var client = HttpClient();
      //create a SecurityContext that doesn't trust the OS's certificates:
      var context = SecurityContext(withTrustedRoots: false);
      var pemBytes = utf8.encode(pem);
      context.setTrustedCertificatesBytes(pemBytes);
      var httpClient = HttpClient(context: context)
        ..badCertificateCallback = _callBack;
      return httpClient;
    };

    return dio;
  }

  // This provide provision to handle the rejected connection request.
  // Setting it false i.e we don't want to continue for rejected connection.
  bool _callBack(X509Certificate cert, String host, int port) {
    return false;
  }
}

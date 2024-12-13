import 'package:dio/dio.dart';
import 'package:health_gauge/services/analytics/sentry_analytics.dart';

class ApiAnalyticsInterceptor extends Interceptor {
  bool logApiFailure;
  bool logApiCallWithBasicData;

  ApiAnalyticsInterceptor({
    this.request = true,
    this.requestHeader = false,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = false,
    this.error = false,
    this.logApiFailure = false,
    this.logApiCallWithBasicData = false,
  });

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var map = <String, dynamic>{};
    map.addAll({'uri': options.uri});

    if (request) {
      map.addAll({
        'method': options.method,
        'responseType': options.responseType.toString(),
        'followRedirects': options.followRedirects,
        'connectTimeout': options.connectTimeout,
        'sendTimeout': options.sendTimeout,
        'receiveTimeout': options.receiveTimeout,
        'receiveDataWhenStatusError': options.receiveDataWhenStatusError,
        'extra': options.extra,
      });
    }
    if (requestHeader) {
      map.addAll(options.headers);
    }
    if (requestBody) {
      map.addAll({'bodyData': options.data});
    }
    if (logApiCallWithBasicData) {
      SentryAnalytics().apiTracking(map);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    var map = <String, dynamic>{};
    map.addAll({'uri': response.requestOptions.uri});

    if (responseHeader) {
      map.addAll({'statusCode': response.statusCode});
      if (response.isRedirect == true) {
        map.addAll({'redirect': response.realUri});
      }
      map.addAll(response.headers.map);
    }
    if (responseBody) {
      map.addAll({'response': response.toString()});
    }

    if (logApiCallWithBasicData) {
      SentryAnalytics().apiTracking(map);
    }
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    var map = <String, dynamic>{};
    if (error) {
      map.addAll({'uri': err.requestOptions.uri, 'error': '$err'});
      if (err.response != null) {
        map.addAll({
          'errorResponse': err.response,
        });
      }
    }
    if (logApiCallWithBasicData || logApiFailure) {
      SentryAnalytics().apiTracking(map);
    }

    handler.next(err);
  }
}

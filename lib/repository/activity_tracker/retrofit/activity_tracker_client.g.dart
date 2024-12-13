// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_tracker_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _ActivityTrackerClient implements ActivityTrackerClient {
  _ActivityTrackerClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<StoreRecognitionActivityResult> storeRecognitionActivity(
      authToken, storeRecognitionActivityRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(storeRecognitionActivityRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<StoreRecognitionActivityResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/StoreRecognitionActivity',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = StoreRecognitionActivityResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetRecognitionActivityListResult> getRecognitionActivityList(
      authToken, getRecognitionActivityListRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(getRecognitionActivityListRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetRecognitionActivityListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetRecognitionActivityList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetRecognitionActivityListResult.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}

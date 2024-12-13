// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _SleepClient implements SleepClient {
  _SleepClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<GetSleepRecordDetailListResult> getSleepRecordDetailList(
      authToken, userRegistrationRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(userRegistrationRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetSleepRecordDetailListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetSleepRecordDtlsList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetSleepRecordDetailListResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<StoreSleepRecordDetailResult> storeSleepRecordDetails(
      authToken, sleepRecordDetailRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = sleepRecordDetailRequest.map((e) => e.toJson()).toList();
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<StoreSleepRecordDetailResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/StoreSleepRecordDtls',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = StoreSleepRecordDetailResult.fromJson(_result.data!);
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

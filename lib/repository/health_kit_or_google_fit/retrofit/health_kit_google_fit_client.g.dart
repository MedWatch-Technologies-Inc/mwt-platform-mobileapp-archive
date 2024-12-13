// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_kit_google_fit_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _HealthKitGoogleFitClient implements HealthKitGoogleFitClient {
  _HealthKitGoogleFitClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<SaveThirdPartyDataTypeResult> saveThirdPartyDataType(
      authToken, dataList) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = dataList.map((e) => e.toJson()).toList();
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SaveThirdPartyDataTypeResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/SaveThirdpartydataType',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SaveThirdPartyDataTypeResult.fromJson(_result.data!);
    print('Sync HealthKit/GoogleFit APIResponse :: ${value.toString()}');
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

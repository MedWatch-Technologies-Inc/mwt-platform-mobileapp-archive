// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_measurement.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _MeasurementClient implements MeasurementClient {
  _MeasurementClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<EstimateResult> getMeasurementEstimate(
      authToken, measurementDetails,cancelToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(measurementDetails.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<EstimateResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/estimate',
                    queryParameters: queryParameters, data: _data,cancelToken: cancelToken)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = EstimateResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetMeasurementDetailListResult> getMeasurementDetailList(
      authToken, getMeasurementDetailListRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(getMeasurementDetailListRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetMeasurementDetailListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetMeasurmentDtlsList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetMeasurementDetailListResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetEcgPpgDetailListResult> getEcgPpgDetailList(
      authToken, getEcgPpgDetailListRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(getEcgPpgDetailListRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetEcgPpgDetailListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetEcgAndPpgData',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetEcgPpgDetailListResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DeleteEstimateResult> deleteEstimateDetailByID(authToken, id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'ID': id};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DeleteEstimateResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/DeleteEstimateDtlsByID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DeleteEstimateResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SetMeasurementUnitResult> setMeasurementUnit(
      authToken, setMeasurementUnitRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(setMeasurementUnitRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SetMeasurementUnitResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/SetMeasuremetnUnit',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SetMeasurementUnitResult.fromJson(_result.data!);
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

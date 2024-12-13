part of 'm_history_client.dart';

class _MHistoryClient implements MHistoryClient {
  _MHistoryClient(this._dio, {this.baseUrl});

  final Dio _dio;
  String? baseUrl;

  @override
  Future<MHistoryResponse> fetchAllMHistory(
      String authToken, MHistoryRequest mHistoryRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(mHistoryRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<MHistoryResponse>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/GetMeasurmentDtlsList',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MHistoryResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MECGPPGResponse> fetchECGPPGData(String authToken, MECGPPGRequest mHistoryRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(mHistoryRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<MHistoryResponse>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/GetEcgAndPpgData',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MECGPPGResponse.fromJson(_result.data!);
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

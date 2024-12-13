part of 'w_history_client.dart';

class _WHistoryClient implements WHistoryClient {
  _WHistoryClient(this._dio, {this.baseUrl});

  final Dio _dio;
  String? baseUrl;

  @override
  Future<WHistoryResponse> fetchAllWHistory(
      String authToken, WHistoryRequest mHistoryRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(mHistoryRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<WHistoryResponse>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/GetWeightMeasurementList',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WHistoryResponse.fromJson(_result.data!);
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

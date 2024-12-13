// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'device_setting_client.dart';

class _DeviceSettingClient implements DeviceSettingClient {
  _DeviceSettingClient(this._dio, {this.baseUrl});

  final Dio _dio;
  String? baseUrl;

  @override
  Future<GetDeviceSettingResult> fetchDeviceSettings(String authToken, int userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll({'UserID': userID});
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<DeviceSettingModel>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/GetDeviceSettings', queryParameters: queryParameters)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetDeviceSettingResult.fromJson(_result.data ?? {});
    return value;
  }

  @override
  Future<MTResponse> fetchMeasurementTimestamp(String authToken, int userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll({'UserID': userID});
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<MTModel>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/GetAllLatestMeasurementTimestamp', queryParameters: queryParameters)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MTResponse.fromJson(_result.data ?? {});
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

  @override
  Future<GetDeviceSettingResult> postDeviceSettings(
      String authToken, UpdateDataRequest updateData) async {
    const _extra = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    _data.addAll(updateData.toJson());
    print(updateData.toJson());
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<DeviceSettingModel>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, ApiConstants.updateDeviceSettings,
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetDeviceSettingResult.fromJson(_result.data ?? {});
    return value;
  }
}

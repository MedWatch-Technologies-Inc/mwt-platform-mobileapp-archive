// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _PreferenceClient implements PreferenceClient {
  _PreferenceClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<GetPreferenceSettingResult> getPreferenceSettings(
      authToken, storeWeightMeasurementRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(storeWeightMeasurementRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetPreferenceSettingResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetPreferenceSettings',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetPreferenceSettingResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<StorePreferenceSettingResult> storePreferenceSettings(
      authToken, UserID, CreatedDateTimeStamp, File) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry('UserID', UserID));
    _data.fields
        .add(MapEntry('CreatedDateTimeStamp', CreatedDateTimeStamp.toString()));
    _data.files.add(MapEntry(
        'File',
        MultipartFile.fromFileSync(File.path,
            filename: File.path.split(Platform.pathSeparator).last)));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<StorePreferenceSettingResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/StorePreferenceSettings',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = StorePreferenceSettingResult.fromJson(_result.data!);
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

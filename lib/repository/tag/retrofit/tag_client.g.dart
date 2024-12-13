// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _TagClient implements TagClient {
  _TagClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<StoreTagRecordDetailResult> storeTagRecordDetails(
      authToken, storeTagRecordDetailRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(storeTagRecordDetailRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<StoreTagRecordDetailResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/StoreTagRecordDtls',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = StoreTagRecordDetailResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<StoreTagRecordDetailResult> editTagRecordDetails(
      authToken, storeTagRecordDetailRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(storeTagRecordDetailRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<StoreTagRecordDetailResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/EditTagRecordDtls',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = StoreTagRecordDetailResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AddTagLabelResult> addTagLabel(authToken, addTagLabelRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(addTagLabelRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AddTagLabelResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AddTagLabel',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AddTagLabelResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AddTagLabelResult> editTagLabel(authToken, editTagLabelRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(editTagLabelRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AddTagLabelResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/EditTagLabel',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AddTagLabelResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AddTagLabelResult> deleteTagLabelByID(authToken, tagLabelId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'TagLabelID': tagLabelId};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AddTagLabelResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/DeleteTagLabelByID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AddTagLabelResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetTagRecordListResult> getTagRecordList(
      authToken, getTagRecordListRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(getTagRecordListRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetTagRecordListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetTagRecordList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetTagRecordListResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetTagLabelListResult> getPreConfigTagLabelList(
      authToken, requestData) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(requestData);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetTagLabelListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetTagLabelList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetTagLabelListResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetTagLabelListResult> getTagLabelList(
      authToken, editTagLabelRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(editTagLabelRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetTagLabelListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetTagLabelList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetTagLabelListResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AddTagLabelResult> deleteTagRecordByID(authToken, tagRecordId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'TagRecordId': tagRecordId};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AddTagLabelResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/DeleteTagRecordByID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AddTagLabelResult.fromJson(_result.data!);
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

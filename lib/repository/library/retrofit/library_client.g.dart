// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _LibraryClient implements LibraryClient {
  _LibraryClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<FetchLibraryEventResult> getMyDriveListByUserId(
      authToken, userId, libraryId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'UserID': userId,
      r'LibraryID': libraryId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FetchLibraryEventResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/LibraryMyDriveListByUserID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FetchLibraryEventResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FetchLibraryEventResult> sharedWithByUserID(authToken, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'UserID': userId};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FetchLibraryEventResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/SharedWithByUserID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FetchLibraryEventResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FetchLibraryEventResult> libraryBinListByUserID(
      authToken, userId, libraryId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'UserID': userId,
      r'LibraryID': libraryId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FetchLibraryEventResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/LibraryBinListByUserID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FetchLibraryEventResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LibraryCreateFolderEventResult> createFolder(
      authToken, libraryCreateFolderEventRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(libraryCreateFolderEventRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LibraryCreateFolderEventResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/CreateFolder',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LibraryCreateFolderEventResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SaveAndUpdateSharedWithResult> deleteLibraryByID(
      authToken, userId, libraryId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'UserID': userId,
      r'LibraryID': libraryId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SaveAndUpdateSharedWithResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/DeleteLibraryByID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SaveAndUpdateSharedWithResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SaveAndUpdateSharedWithResult> deleteLibraryPermanentlyByID(
      authToken, userId, libraryId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'UserID': userId,
      r'LibraryID': libraryId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SaveAndUpdateSharedWithResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/DeleteLibraryPermanentlyByID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SaveAndUpdateSharedWithResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FetchLibraryEventResult> updateLinkedAccess(
      authToken, updateLinkedAccessEventRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(updateLinkedAccessEventRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FetchLibraryEventResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/UpdateLinkedAccess',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FetchLibraryEventResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FetchLibraryEventResult> uploadFileIntoDrive(
      authToken, UserID, UploadFile, LibraryID, currentDateTimeStamp) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry('UserID', UserID.toString()));
    _data.files.add(MapEntry(
        'UploadFile',
        MultipartFile.fromFileSync(UploadFile.path,
            filename: UploadFile.path.split(Platform.pathSeparator).last)));
    _data.fields.add(MapEntry('LibraryID', LibraryID.toString()));
    _data.fields
        .add(MapEntry('CreatedDateTimeStamp', currentDateTimeStamp.toString()));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FetchLibraryEventResult>(Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: 'multipart/form-data')
            .compose(_dio.options, '/UploadFileIntoDrive',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FetchLibraryEventResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SaveAndUpdateSharedWithResult> moveDrive(
      authToken, userId, libraryId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'UserID': userId,
      r'LibraryID': libraryId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SaveAndUpdateSharedWithResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/MoveDrive',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SaveAndUpdateSharedWithResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SaveAndUpdateSharedWithResult> deleteShared(
      authToken, userId, libraryId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'UserID': userId,
      r'LibraryID': libraryId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SaveAndUpdateSharedWithResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/DeleteShared',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SaveAndUpdateSharedWithResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SaveAndUpdateSharedWithResult> saveAndUpdateSharedWith(
      authToken, saveAndUpdateSharedWithRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(saveAndUpdateSharedWithRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SaveAndUpdateSharedWithResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/SaveandUpdateSharedWith',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SaveAndUpdateSharedWithResult.fromJson(_result.data!);
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

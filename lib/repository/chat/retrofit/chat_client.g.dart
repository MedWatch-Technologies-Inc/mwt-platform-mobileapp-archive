// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _ChatClient implements ChatClient {
  _ChatClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AccessChattedWithResult> getAccessChattedWith(
      authToken, accessChattedWithRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'fromuserId': accessChattedWithRequest
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AccessChattedWithResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AccessChattedWith',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AccessChattedWithResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AccessHistoryWithTwoUserResult> getAccessChatHistoryTwoUsers(
      authToken, fromUserId, toUserId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'fromuserId': fromUserId,
      r'touserId': toUserId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AccessHistoryWithTwoUserResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AccessChatHistoryTwoUsers',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AccessHistoryWithTwoUserResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AccessCreateChatGroupResult> accessCreateChatGroup(
      authToken, groupName, memberIds) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'groupName': groupName,
      r'memberIds': memberIds
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AccessCreateChatGroupResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AccessCreateChatGroup',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AccessCreateChatGroupResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AccessChatHistoryGroupResult> accessGroupChatHistory(
      authToken, groupName) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'groupName': groupName};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AccessChatHistoryGroupResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AccessChatHistoryGroup',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AccessChatHistoryGroupResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AccessGroupParticipantResult> accessGroupParticipants(
      authToken, groupName) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'groupName': groupName};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AccessGroupParticipantResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AccessGroupParticipants',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AccessGroupParticipantResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AccessSendGroupResult> accessSendGroup(
      authToken, sendGroupMessageEventRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(sendGroupMessageEventRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AccessSendGroupResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AccessSendGroup',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AccessSendGroupResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GroupListResult> accessGetMyGroupList(authToken, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'UserID': userId};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GroupListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AccessGetMyGroupList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GroupListResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GroupRemoveResult> accessDeleteChatGroup(authToken, groupName) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'groupName': groupName};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GroupRemoveResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AccessDeleteChatGroup',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GroupRemoveResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AddGroupParticipantResult> accessAddParticipant(
      authToken, groupName, memberIds) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'groupName': groupName,
      r'MembersIDs': memberIds
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AddGroupParticipantResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AccessAddParticipant',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AddGroupParticipantResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RemoveGroupParticipantResult> accessRemoveParticipant(
      authToken, groupName, memberIds) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'groupName': groupName,
      r'MembersIDs': memberIds
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RemoveGroupParticipantResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AccessRemoveParticipant',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RemoveGroupParticipantResult.fromJson(_result.data!);
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

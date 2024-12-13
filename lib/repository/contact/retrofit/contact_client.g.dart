// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _ContactClient implements ContactClient {
  _ContactClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<GetContactListResult> getContactList(
      authToken, loadContactListRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(loadContactListRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetContactListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetContactList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetContactListResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DeleteContactByUserIdResult> deleteContactByUserId(
      authToken, contactFromUserId, contactToUserId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'ContactFromUserID': contactFromUserId,
      r'ContactToUserId': contactToUserId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DeleteContactByUserIdResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/DeleteContactByUserId',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DeleteContactByUserIdResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetSendingInvitationListResult> getSendingInvitationList(
      authToken, getInvitationListEventRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(getInvitationListEventRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetSendingInvitationListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetSendingInvitationList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetSendingInvitationListResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetPendingInvitationListResult> getPendingInvitationList(
      authToken, getInvitationRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(getInvitationRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetPendingInvitationListResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetPendingInvitationList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetPendingInvitationListResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AcceptOrRejectInvitationResult> acceptOrRejectInvitation(
      authToken, contactId, isAccepted) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'ContactID': contactId,
      r'IsAccepted': isAccepted
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AcceptOrRejectInvitationResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/AcceptOrRejectInvitation',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AcceptOrRejectInvitationResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchLeadsResult> searchLeads(
      authToken, loggedInUserId, searchText) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'LoggedinUserID': loggedInUserId,
      r'SearchText': searchText
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SearchLeadsResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/SearchLeads',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SearchLeadsResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SendInvitationResult> sendInvitation(
      authToken, loggedInUserId, inviteeUserId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'LoggedinUserID': loggedInUserId,
      r'InviteeUserID': inviteeUserId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SendInvitationResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/SendInvitation',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SendInvitationResult.fromJson(_result.data!);
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

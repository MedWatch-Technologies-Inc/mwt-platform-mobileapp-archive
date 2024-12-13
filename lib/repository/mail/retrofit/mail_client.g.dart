// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _MailClient implements MailClient {
  _MailClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<MessageDetailListModel> getMessageDetailByMessageId(
      authToken, messageId, loggedInEmailId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'MessageID': messageId,
      r'LogedInEmailID': loggedInEmailId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MessageDetailListModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetMessagedetlsByMessageid',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MessageDetailListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SendResponseByMessageIdAndTypeIdResult>
      sendResponseByMessageIDAndTypeID(
          authToken, sendResponseMessageEventRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(sendResponseMessageEventRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SendResponseByMessageIdAndTypeIdResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/SendResponseByMessageIDAndTypeID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value =
        SendResponseByMessageIdAndTypeIdResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<EmptyMessagesFromTrashResult> emptyMessagesFromTrash(
      authToken, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'UserID': userId};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<EmptyMessagesFromTrashResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/EmptyMessagesFromTrash',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = EmptyMessagesFromTrashResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MarkAsReadByMessageTypeIdResult> markAsReadByMessageTypeID(
      authToken, userId, messageTypeId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'UserID': userId,
      r'MessageTypeid': messageTypeId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MarkAsReadByMessageTypeIdResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/MarkAsReadByMessageTypeID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MarkAsReadByMessageTypeIdResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MarkAsReadByMessageIdResult> markAsReadByMessageID(
      authToken, messageId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'MessageId': messageId};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MarkAsReadByMessageIdResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/MarkAsReadByMessageID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MarkAsReadByMessageIdResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MultipleMessageDeleteFromTrashResult> multipleMessageDeleteFromTrash(
      authToken, multipleTrashMessageDeleteEventRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(multipleTrashMessageDeleteEventRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MultipleMessageDeleteFromTrashResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/MultipleMessageDeleteFromTrash',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MultipleMessageDeleteFromTrashResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MultipleMessageDeleteFromTrashResult> multipleDeleteMessages(
      authToken, multipleTrashMessageDeleteEventRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(multipleTrashMessageDeleteEventRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MultipleMessageDeleteFromTrashResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/MultipleDeleteMessages',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MultipleMessageDeleteFromTrashResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MultipleMessageDeleteFromTrashResult> deleteMessageById(
      authToken, messageId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'MessageID': messageId};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MultipleMessageDeleteFromTrashResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/DeleteMessagebyId',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MultipleMessageDeleteFromTrashResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MultipleMessageDeleteFromTrashResult> restoreMessageByID(
      authToken, messageId, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'MessageID': messageId,
      r'UserID': userId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MultipleMessageDeleteFromTrashResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/RestoreMessageByID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MultipleMessageDeleteFromTrashResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SendMessageResult> sendMessage(
      authToken, sendMessageEventRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(sendMessageEventRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SendMessageResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/Sendmessage',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SendMessageResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MessageListModel> getMessageListByMessageTypeId(
      authToken, sendMessageEventRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(sendMessageEventRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MessageListModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetMessagelistByMessageTypeid',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MessageListModel.fromJson(_result.data!);
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

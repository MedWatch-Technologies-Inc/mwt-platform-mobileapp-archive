// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _CalendarClient implements CalendarClient {
  _CalendarClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<GetEventListByUserIdResult> getEventListByUserID(
      authToken, userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'UserID': userID};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetEventListByUserIdResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetEventListByUserID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetEventListByUserIdResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CalendarEventDataResult> calendarEventData(authToken, request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CalendarEventDataResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/CalendarEventData',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CalendarEventDataResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetEventDetailByUserIdAndEventIdResult>
      getEventDetailsByUserIDAndEventID(authToken, userId, eventId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'UserID': userId,
      r'EventID': eventId
    };
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetEventDetailByUserIdAndEventIdResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/GetEventDetailsByUserIDAndEventID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value =
        GetEventDetailByUserIdAndEventIdResult.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DeleteEventByEventIdResult> deleteEventByEventID(
      authToken, eventId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'EventID': eventId};
    final _headers = <String, dynamic>{r'authorization': authToken};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DeleteEventByEventIdResult>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/DeleteEventByEventID',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DeleteEventByEventIdResult.fromJson(_result.data!);
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

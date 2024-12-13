import 'package:dio/dio.dart';
import 'package:health_gauge/repository/calendar/model/calendar_event_data_result.dart';
import 'package:health_gauge/repository/calendar/model/delete_event_by_event_id_result.dart';
import 'package:health_gauge/repository/calendar/model/get_event_detail_by_user_id_and_event_id_result.dart';
import 'package:health_gauge/repository/calendar/request/calendar_event_data_request.dart';
import 'package:health_gauge/repository/calendar/retrofit/calendar_client.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/models/get_events.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class CalendarRepository {
  late CalendarClient _calendarClient;
  String? baseUrl;

  CalendarRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _calendarClient =
        CalendarClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<AccessGetCalendarEventModel>> getEventListByUserID(
      int userId) async {
    var response = ApiResponseWrapper<AccessGetCalendarEventModel>();
    try {
      var result = await _calendarClient.getEventListByUserID(
          '${Constants.authToken}', userId);
      return response..setData(AccessGetCalendarEventModel.mapper(result));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<CalendarEventDataResult>> calendarEventData(
      CalendarEventDataRequest request) async {
    var response = ApiResponseWrapper<CalendarEventDataResult>();
    try {
      return response
        ..setData(await _calendarClient.calendarEventData(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<GetEventDetailByUserIdAndEventIdResult>>
      getEventDetailsByUserIDAndEventID(int userId, int eventId) async {
    var response = ApiResponseWrapper<GetEventDetailByUserIdAndEventIdResult>();
    try {
      var result = await _calendarClient.getEventDetailsByUserIDAndEventID(
        '${Constants.authToken}',
        userId,
        eventId,
      );
      return response..setData(GetEventDetailByUserIdAndEventIdResult.mapper(result));

    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<DeleteEventByEventIdResult>> deleteEventByEventID(
      String eventId) async {
    var response = ApiResponseWrapper<DeleteEventByEventIdResult>();
    try {
      return response
        ..setData(await _calendarClient.deleteEventByEventID(
            '${Constants.authToken}', eventId));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }
}

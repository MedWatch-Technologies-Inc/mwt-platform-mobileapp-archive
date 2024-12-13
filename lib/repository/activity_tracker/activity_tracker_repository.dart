import 'package:dio/dio.dart';
import 'package:health_gauge/repository/activity_tracker/model/get_recognition_activity_list_result.dart';
import 'package:health_gauge/repository/activity_tracker/model/store_recognition_activity_result.dart';
import 'package:health_gauge/repository/activity_tracker/request/get_recognition_activity_list_request.dart';
import 'package:health_gauge/repository/activity_tracker/request/store_recognition_activity_request.dart';
import 'package:health_gauge/repository/activity_tracker/retrofit/activity_tracker_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';
import 'dart:developer' as log;


class ActivityTrackerRepository {
  late ActivityTrackerClient _activityTrackerClient;
  String? baseUrl;

  ActivityTrackerRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _activityTrackerClient =
        ActivityTrackerClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<StoreRecognitionActivityResult>>
      storeRecognitionActivity(StoreRecognitionActivityRequest request) async {
    var response = ApiResponseWrapper<StoreRecognitionActivityResult>();
    try {
      log.log('activity_data_storing  ${request.toJson()}');
      var result = await _activityTrackerClient.storeRecognitionActivity(
          '${Constants.authToken}', request);
      return response..setData(result);
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService()
          .printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService()
          .printLog(tag: 'Api exception', message: exception.toString());
      LoggingService()
          .printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<GetRecognitionActivityListResult>>
      getRecognitionActivityList(
          GetRecognitionActivityListRequest request) async {
    var response = ApiResponseWrapper<GetRecognitionActivityListResult>();
    try {
      var result = await _activityTrackerClient.getRecognitionActivityList(
          '${Constants.authToken}', request);

      return response..setData(result);
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService()
          .printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService()
          .printLog(tag: 'Api exception', message: exception.toString());
      LoggingService()
          .printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }
}

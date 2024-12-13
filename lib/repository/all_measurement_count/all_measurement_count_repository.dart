import 'package:dio/dio.dart';
import 'package:health_gauge/repository/all_measurement_count/model/get_all_measurement_count_result.dart';
import 'package:health_gauge/repository/all_measurement_count/request/get_all_measurement_count_request.dart';
import 'package:health_gauge/repository/all_measurement_count/retrofit/all_measurement_count_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class AllMeasurementCountRepository {
  late AllMeasurementCountClient _allMeasurementCountClient;

  AllMeasurementCountRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _allMeasurementCountClient = AllMeasurementCountClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetAllMeasurementCountResult>> getPreferenceSettings(
      String userID) async {
    var response = ApiResponseWrapper<GetAllMeasurementCountResult>();
    try {
      return response
        ..setData(await _allMeasurementCountClient.getPreferenceSettings(
            '${Constants.authToken}', userID));
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

  Future<ApiResponseWrapper<GetAllMeasurementCountResult>> getAllMeasurementCountData(
      GetAllMeasurementCountRequest request) async {
    var response = ApiResponseWrapper<GetAllMeasurementCountResult>();
    try {
      return response
        ..setData(await _allMeasurementCountClient.getAllMeasurementCountData(
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
}
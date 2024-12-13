import 'package:dio/dio.dart';
import 'package:health_gauge/repository/heart_rate_monitor/model/get_hr_data_response.dart';
import 'package:health_gauge/repository/heart_rate_monitor/model/save_hr_data_response.dart';
import 'package:health_gauge/repository/heart_rate_monitor/request/get_hr_data_request.dart';
import 'package:health_gauge/repository/heart_rate_monitor/request/save_hr_data_request.dart';
import 'package:health_gauge/repository/heart_rate_monitor/retrofit/heart_rate_monitor_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class HeartRateMonitorRepository {
  late HeartRateMonitorClient _heartRateMonitorClient;
  String? baseUrl;

  HeartRateMonitorRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _heartRateMonitorClient = HeartRateMonitorClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetHrDataResponse>>
  getHeartRateRecordDetailList(GetHrDataRequest request) async {
    var response = ApiResponseWrapper<GetHrDataResponse>();
    try {
      print("sssssss");
      var result = await _heartRateMonitorClient.getHrDataList(
          '${Constants.authToken}', request);
      return response..setData(result);
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

  Future<ApiResponseWrapper<SaveHrDataResponse>>
  storeHeartRateRecordDetails(SaveHrDataRequest request) async {
    var response = ApiResponseWrapper<SaveHrDataResponse>();
    try {
      var result = await _heartRateMonitorClient.storeHrData(
          '${Constants.authToken}', request);
      return response..setData(result);
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

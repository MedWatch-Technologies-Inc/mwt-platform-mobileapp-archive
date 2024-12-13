import 'package:dio/dio.dart';
import 'package:health_gauge/repository/blood_pressure_monitor/model/get_bp_data_response.dart';
import 'package:health_gauge/repository/blood_pressure_monitor/request/get_bp_data_request.dart';
import 'package:health_gauge/repository/blood_pressure_monitor/request/save_bp_data_request.dart';
import 'package:health_gauge/repository/blood_pressure_monitor/retrofit/blood_pressure_monitor_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

import 'model/save_bp_data_response.dart';

class BloodPressureMonitorRepository {
  late BloodPressureMonitorClient _bpMonitorClient;
  String? baseUrl;

  BloodPressureMonitorRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _bpMonitorClient = BloodPressureMonitorClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetBPDataResponse>>
  getBloodPressureRecordDetailList(GetBPDataRequest request) async {
    var response = ApiResponseWrapper<GetBPDataResponse>();
    try {
      var result = await _bpMonitorClient.getBPDataList(
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

  Future<ApiResponseWrapper<SaveBPDataResponse>>
  storeBloodPressureRecordDetails(SaveBPDataRequest request) async {
    var response = ApiResponseWrapper<SaveBPDataResponse>();
    try {
      var result = await _bpMonitorClient.storeBPData(
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

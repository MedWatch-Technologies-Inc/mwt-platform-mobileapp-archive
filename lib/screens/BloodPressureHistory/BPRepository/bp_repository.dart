import 'package:dio/dio.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPClient/bp_client.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_reponse.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_save_response.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPRequest/bp_h_request.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPRequest/bp_save_request.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class BPRepository {
  late BPClient _bpClient;
  String? baseUrl;

  BPRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _bpClient = BPClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<BPHistoryResponse>>
  fetchAllBPHistory(BPHistoryRequest request) async {
    var response = ApiResponseWrapper<BPHistoryResponse>();
    try {
      var result = await _bpClient.fetchAllBPHistory(
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

  Future<ApiResponseWrapper<BPSaveResponse>>
  saveBPData(BPSaveRequest request) async {
    var response = ApiResponseWrapper<BPSaveResponse>();
    try {
      var result = await _bpClient.saveBPData(
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

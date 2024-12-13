import 'package:dio/dio.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHClient/m_history_client.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHRequest/m_ecg_ppg_request.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHRequest/m_history_request.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_ecg_ppg_response.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_response.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class MHistoryRepository {
  late MHistoryClient _mHistoryClient;
  String? baseUrl;

  MHistoryRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _mHistoryClient = MHistoryClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<MHistoryResponse>> fetchAllMHistory(MHistoryRequest request) async {
    var response = ApiResponseWrapper<MHistoryResponse>();
    try {
      var result = await _mHistoryClient.fetchAllMHistory('${Constants.authToken}', request);
      return response..setData(result);
    } on DioException catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<MECGPPGResponse>> fetchECGPPGData(MECGPPGRequest request) async {
    var response = ApiResponseWrapper<MECGPPGResponse>();
    try {
      var result = await _mHistoryClient.fetchECGPPGData('${Constants.authToken}', request);
      return response..setData(result);
    } on DioException catch (error, stacktrace) {
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

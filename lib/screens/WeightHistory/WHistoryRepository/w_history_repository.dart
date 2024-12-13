import 'package:dio/dio.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHClient/m_history_client.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHRequest/m_ecg_ppg_request.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHRequest/m_history_request.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_ecg_ppg_response.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_response.dart';
import 'package:health_gauge/screens/WeightHistory/WHistoryRepository/WHClient/w_history_client.dart';
import 'package:health_gauge/screens/WeightHistory/WHistoryRepository/WHRequest/w_history_request.dart';
import 'package:health_gauge/screens/WeightHistory/WHistoryRepository/WHResponse/w_history_response.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class WHistoryRepository {
  late WHistoryClient _wHistoryClient;
  String? baseUrl;

  WHistoryRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _wHistoryClient = WHistoryClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<WHistoryResponse>> fetchAllWHistory(WHistoryRequest request) async {
    var response = ApiResponseWrapper<WHistoryResponse>();
    try {
      var result = await _wHistoryClient.fetchAllWHistory('${Constants.authToken}', request);
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

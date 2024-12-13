import 'package:dio/dio.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPClient/bp_client.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_reponse.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPRequest/bp_h_request.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTClient/ot_client.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTRequest/ot_h_request.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_model.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_response.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_save_response.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class OTRepository {
  late OTClient _otClient;
  String? baseUrl;

  OTRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _otClient = OTClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<OTHistoryResponse>>
  fetchAllOTHistory(OTHistoryRequest request) async {
    var response = ApiResponseWrapper<OTHistoryResponse>();
    try {
      var result = await _otClient.fetchAllOTHistory(
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

  Future<ApiResponseWrapper<OTSaveResponse>> saveOTData(
      List<OTHistoryModel> request) async {
    var response = ApiResponseWrapper<OTSaveResponse>();
    try {
      var result = await _otClient.saveOTData(
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

import 'package:dio/dio.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPClient/bp_client.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_reponse.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPRequest/bp_h_request.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/HRClient/hr_client.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/HRRequest/hr_request.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/HRResponse/hr_response.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class HRRepository {
  late HRClient _hrClient;
  String? baseUrl;

  HRRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _hrClient = HRClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<HRResponse>>
  fetchAllHRData(HRRequest request) async {
    var response = ApiResponseWrapper<HRResponse>();
    try {
      var result = await _hrClient.fetchAllHRData(
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

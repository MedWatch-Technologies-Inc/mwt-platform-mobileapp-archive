import 'dart:convert';
import 'dart:math';
import 'dart:developer' as log;

import 'package:dio/dio.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

import 'model/save_third_party_data_type_result.dart';
import 'request/save_third_party_data_type_request.dart';
import 'retrofit/health_kit_google_fit_client.dart';

class HealthKitGoogleFitRepository {
  late HealthKitGoogleFitClient _healthKitGoogleFitClient;

  HealthKitGoogleFitRepository() {
    var dio = ServiceManager.get().getDioClient();
    _healthKitGoogleFitClient =
        HealthKitGoogleFitClient(dio, baseUrl: Constants.baseUrl);
  }

  Future<ApiResponseWrapper<SaveThirdPartyDataTypeResult>>
      saveThirdPartyDataType(List<SaveThirdPartyDataTypeRequest> request) async {
    log.log('Payload: ${jsonEncode(request.map((e) => e.toJson()).toList())}');
    var response = ApiResponseWrapper<SaveThirdPartyDataTypeResult>();
    try {
      return response..setData(await _healthKitGoogleFitClient.saveThirdPartyDataType(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
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

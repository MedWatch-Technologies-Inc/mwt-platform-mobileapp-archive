import 'package:dio/dio.dart';
import 'package:health_gauge/repository/weight/model/get_weight_measurement_list_result.dart';
import 'package:health_gauge/repository/weight/model/store_weight_measurement_result.dart';
import 'package:health_gauge/repository/weight/request/get_weight_measurement_list_request.dart';
import 'package:health_gauge/repository/weight/request/store_weight_measurement_request.dart';
import 'package:health_gauge/repository/weight/retrofit/weight_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class WeightRepository {
  late WeightClient _weightClient;
  String? baseUrl;

  WeightRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _weightClient = WeightClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetWeightMeasurementListResult>>
      getWeightMeasurementList(GetWeightMeasurementListRequest request) async {
    var response = ApiResponseWrapper<GetWeightMeasurementListResult>();
    try {
      return response
        ..setData(await _weightClient.getWeightMeasurementList(
            '${Constants.authToken}', request));
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

  Future<ApiResponseWrapper<StoreWeightMeasurementResult>>
      storeWeightMeasurement(
          List<StoreWeightMeasurementRequest> request) async {
    var response = ApiResponseWrapper<StoreWeightMeasurementResult>();
    try {
      return response
        ..setData(await _weightClient.storeWeightMeasurement(
            '${Constants.authToken}', request));
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

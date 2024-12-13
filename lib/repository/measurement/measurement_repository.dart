import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:health_gauge/repository/measurement/model/delete_estimate_result.dart';
import 'package:health_gauge/repository/measurement/model/estimate_result.dart';
import 'package:health_gauge/repository/measurement/model/get_ecg_ppg_detail_list_result.dart';
import 'package:health_gauge/repository/measurement/model/get_measurement_detail_list_result.dart';
import 'package:health_gauge/repository/measurement/model/set_measurement_unit_result.dart';
import 'package:health_gauge/repository/measurement/request/add_measurement_request.dart';
import 'package:health_gauge/repository/measurement/request/get_ecg_ppg_detail_list_request.dart';
import 'package:health_gauge/repository/measurement/request/get_measurement_detail_list_request.dart';
import 'package:health_gauge/repository/measurement/request/set_measurement_unit_request.dart';
import 'package:health_gauge/repository/measurement/retrofit/client_measurement.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/helpers/flutter_logs_service.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class MeasurementRepository {
  late MeasurementClient _measurementClient;

  MeasurementRepository() {
    var dio = ServiceManager.get().getDioClient();
    _measurementClient = MeasurementClient(dio, baseUrl: Constants.baseUrl);
  }

  Future<ApiResponseWrapper<EstimateResult>>  getEstimate(
      AddMeasurementRequest request, {CancelToken? cancelToken}) async {
    cancelToken??=CancelToken();
    var response = ApiResponseWrapper<EstimateResult>();
    try {
      LoggingService().info('API', 'Estimate API successful');
        // log('getEstimate_ : ${request.toJson()}');
      return response
        ..setData(await _measurementClient.getMeasurementEstimate(
            '${Constants.authToken}', request,cancelToken));

    } on DioError catch (error, stacktrace) {
      LoggingService().warning('API', 'Estimate API',error: error,stackTrace: stacktrace);

      LoggingService()
          .printLog(tag: 'Restaurant dio error', message: error.toString());
      LoggingService().printLog(
          tag: 'Restaurant dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: exception.toString());
      LoggingService().printLog(
          tag: 'Restaurant api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<GetMeasurementDetailListResult>>
      getMeasurementDetailList(GetMeasurementDetailListRequest request) async {
    var response = ApiResponseWrapper<GetMeasurementDetailListResult>();
    print('GetMeasurementDetailListRequest ${request.toJson()}');
    try {

      return response
        ..setData(await _measurementClient.getMeasurementDetailList(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }



  Future<ApiResponseWrapper<GetEcgPpgDetailListResult>>
  getEcgPpgDetailList(GetEcgPpgDetailListRequest request) async {
    var response = ApiResponseWrapper<GetEcgPpgDetailListResult>();
    try {
      return response
        ..setData(await _measurementClient.getEcgPpgDetailList(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<DeleteEstimateResult>> deleteEstimateDetailByID(
      int id) async {
    var response = ApiResponseWrapper<DeleteEstimateResult>();
    try {
      return response
        ..setData(await _measurementClient.deleteEstimateDetailByID(
            '${Constants.authToken}', id));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<SetMeasurementUnitResult>> setMeasurementUnit(
      SetMeasurementUnitRequest request) async {
    var response = ApiResponseWrapper<SetMeasurementUnitResult>();
    try {
      return response
        ..setData(await _measurementClient.setMeasurementUnit(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }
}

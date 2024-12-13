import 'package:dio/dio.dart';
import 'dart:developer' as log;
import 'package:health_gauge/repository/sleep/model/get_sleep_record_detail_list_result.dart';
import 'package:health_gauge/repository/sleep/model/store_sleep_record_detail_result.dart';
import 'package:health_gauge/repository/sleep/request/get_sleep_record_detail_list_request.dart';
import 'package:health_gauge/repository/sleep/request/store_sleep_record_detail_request.dart';
import 'package:health_gauge/repository/sleep/retrofit/sleep_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class SleepRepository {
  late SleepClient _sleepClient;
  String? baseUrl;

  SleepRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _sleepClient = SleepClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetSleepRecordDetailListResult>>
      getSleepRecordDetailList(GetSleepRecordDetailListRequest request) async {
    var response = ApiResponseWrapper<GetSleepRecordDetailListResult>();
    try {
      var result = await _sleepClient.getSleepRecordDetailList(
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

  Future<ApiResponseWrapper<StoreSleepRecordDetailResult>>
      storeSleepRecordDetails(List<StoreSleepRecordDetailRequest> request) async {
    var response = ApiResponseWrapper<StoreSleepRecordDetailResult>();
    try {
      log.log('Sleep_data_storing  ${request.map((e) => e.toJson()).toList()}');
      var result = await _sleepClient.storeSleepRecordDetails(
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

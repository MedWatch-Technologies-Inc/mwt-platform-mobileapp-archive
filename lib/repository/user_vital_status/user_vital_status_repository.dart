import 'dart:math';

import 'package:dio/dio.dart';
import 'dart:developer' as log;
import 'package:health_gauge/repository/user_vital_status/model/get_user_vital_status_result.dart';
import 'package:health_gauge/repository/user_vital_status/model/save_user_vital_status_result.dart';
import 'package:health_gauge/repository/user_vital_status/request/get_user_vital_status_request.dart';
import 'package:health_gauge/repository/user_vital_status/request/save_user_vital_status_request.dart';
import 'package:health_gauge/repository/user_vital_status/retrofit/user_vital_status_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class UserVitalStatusRepository {
  late UserVitalStatusClient _userVitalStatusClient;
  String? baseUrl;

  UserVitalStatusRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _userVitalStatusClient =
        UserVitalStatusClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetUserVitalStatusResult>> getUserVitalStatus(
      GetUserVitalStatusRequest request) async {


    var response = ApiResponseWrapper<GetUserVitalStatusResult>();
    try {
      var result = await _userVitalStatusClient.getUserVitalStatus(
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

  Future<ApiResponseWrapper<SaveUserVitalStatusResult>> saveUserVitalStatus(
      List<SaveUserVitalStatusRequest> request) async {
    var response = ApiResponseWrapper<SaveUserVitalStatusResult>();
    try {
      log.log('Vital_status_storing  ${request.map((e) => e.toJson()).toList()}');
      var result = await _userVitalStatusClient.saveUserVitalStatus(
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

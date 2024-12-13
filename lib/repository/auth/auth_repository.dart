import 'package:dio/dio.dart';
import 'package:health_gauge/repository/auth/model/login_result.dart';
import 'package:health_gauge/repository/auth/request/user_registration_request.dart';
import 'package:health_gauge/repository/auth/retrofit/auth_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';

class AuthRepository {
  late AuthClient _authClient;
  String? baseUrl;

  AuthRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _authClient = AuthClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<LoginResult>> userLogin(
      String userName, String password, String deviceToken) async {
    var response = ApiResponseWrapper<LoginResult>();
    try {
      var result = await _authClient.userLogin(userName, password, deviceToken);
      if (result.result!) {
        Constants.authToken = result.salt!;
        Constants.header = {
          'Authorization': '${Constants.authToken}',
          'Content-Type': 'application/json',
        };
        preferences?.setString(Constants.prefTokenKey, Constants.authToken);
      }
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

  Future<ApiResponseWrapper<LoginResult>> userRegistration(
      UserRegistrationRequest request) async {
    var response = ApiResponseWrapper<LoginResult>();
    try {
      var result = await _authClient.userRegistration(request);
      if (result.result!) {
        Constants.authToken = result.salt!;
        Constants.header = {
          'Authorization': '${Constants.authToken}',
          'Content-Type': 'application/json',
        };
        preferences?.setString(Constants.prefTokenKey, Constants.authToken);
      }
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

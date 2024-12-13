import 'package:dio/dio.dart';
import 'package:health_gauge/repository/auth/model/login_result.dart';
import 'package:health_gauge/repository/user/model/change_password_by_user_id_result.dart';
import 'package:health_gauge/repository/user/model/forget_password_choose_medium_result.dart';
import 'package:health_gauge/repository/user/model/forget_password_using_user_name_result.dart';
import 'package:health_gauge/repository/user/model/forget_user_id_result.dart';
import 'package:health_gauge/repository/user/model/reset_password_using_user_name_result.dart';
import 'package:health_gauge/repository/user/model/user_exist_result.dart';
import 'package:health_gauge/repository/user/model/verify_otp_result.dart';
import 'package:health_gauge/repository/user/request/edit_user_request.dart';
import 'package:health_gauge/repository/user/request/forget_password_choose_medium_request.dart';
import 'package:health_gauge/repository/user/request/forget_password_using_user_name_request.dart';
import 'package:health_gauge/repository/user/request/reset_password_using_user_name_request.dart';
import 'package:health_gauge/repository/user/request/verify_otp_request.dart';
import 'package:health_gauge/repository/user/retrofit/user_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class UserRepository {
  late UserClient _userClient;
  String? baseUrl;

  UserRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _userClient = UserClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<ForgetUserIdResult>> forgetUserID(
      String email) async {
    var response = ApiResponseWrapper<ForgetUserIdResult>();
    try {
      return response..setData(await _userClient.forgetUserID(email));
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

  Future<ApiResponseWrapper<ForgetPasswordUsingUserNameResult>>
      forgetPasswordUsingUserName(
          ForgetPasswordUsingUserNameRequest request) async {
    var response = ApiResponseWrapper<ForgetPasswordUsingUserNameResult>();
    try {
      return response
        ..setData(await _userClient.forgetPasswordUsingUserName(request));
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

  Future<ApiResponseWrapper<ForgetPasswordChooseMediumResult>>
      forgetPasswordChooseMedium(
          ForgetPasswordChooseMediumRequest request) async {
    var response = ApiResponseWrapper<ForgetPasswordChooseMediumResult>();
    try {
      return response
        ..setData(await _userClient.forgetPasswordChooseMedium(request));
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

  Future<ApiResponseWrapper<VerifyOtpResult>> verifyOTP(
      VerifyOtpRequest request) async {
    var response = ApiResponseWrapper<VerifyOtpResult>();
    try {
      return response..setData(await _userClient.verifyOTP(request));
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

  Future<ApiResponseWrapper<ResetPasswordUsingUserNameResult>>
      resetPasswordUsingUserName(
          ResetPasswordUsingUserNameRequest request) async {
    var response = ApiResponseWrapper<ResetPasswordUsingUserNameResult>();
    try {
      return response
        ..setData(await _userClient.resetPasswordUsingUserName(request));
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

  Future<ApiResponseWrapper<ChangePasswordByUserIdResult>>
      changePasswordByUserID(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    var response = ApiResponseWrapper<ChangePasswordByUserIdResult>();
    try {
      return response
        ..setData(await _userClient.changePasswordByUserID(
          '${Constants.authToken}',
          userId,
          oldPassword,
          newPassword,
        ));
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

  Future<ApiResponseWrapper<LoginResult>> getUSerDetailsByUserID(
    String userId,
  ) async {
    var response = ApiResponseWrapper<LoginResult>();
    try {
      return response
        ..setData(await _userClient.getUSerDetailsByUserID(
          '${Constants.authToken}',
          userId,
        ));
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

  Future<ApiResponseWrapper<LoginResult>> editUser(
      EditUserRequest request) async {
    var response = ApiResponseWrapper<LoginResult>();
    try {
      return response
        ..setData(
            await _userClient.editUser('${Constants.authToken}', request));
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

  Future<ApiResponseWrapper<UserExistResult>>
  checkDuplicateUserIDAndEmail(
      String emailOrUserID,
      int type,
      ) async {
    var response = ApiResponseWrapper<UserExistResult>();
    try {
      return response
        ..setData(await _userClient.checkDuplicateUserIDAndEmail(
          emailOrUserID,
          type,
        ));
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

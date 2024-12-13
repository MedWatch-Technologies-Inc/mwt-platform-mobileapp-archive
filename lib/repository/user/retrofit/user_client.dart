import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:health_gauge/models/user_model.dart';
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
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:retrofit/retrofit.dart';

part 'user_client.g.dart';

@RestApi()
abstract class UserClient {
  factory UserClient(Dio dio, {String baseUrl}) = _UserClient;

  @POST(ApiConstants.forgetUserID)
  Future<ForgetUserIdResult> forgetUserID(
    @Query(ApiConstants.email) String email,
  );

  @POST(ApiConstants.forgetPasswordUsingUserName)
  Future<ForgetPasswordUsingUserNameResult> forgetPasswordUsingUserName(
    @Body()
        ForgetPasswordUsingUserNameRequest forgetPasswordUsingUserNameRequest,
  );

  @POST(ApiConstants.forgetPasswordChooseMedium)
  Future<ForgetPasswordChooseMediumResult> forgetPasswordChooseMedium(
    @Body() ForgetPasswordChooseMediumRequest forgetPasswordChooseMediumRequest,
  );

  @POST(ApiConstants.verifyOTP)
  Future<VerifyOtpResult> verifyOTP(
    @Body() VerifyOtpRequest verifyOtpRequest,
  );

  @POST(ApiConstants.resetPasswordUsingUserName)
  Future<ResetPasswordUsingUserNameResult> resetPasswordUsingUserName(
    @Body() ResetPasswordUsingUserNameRequest resetPasswordUsingUserNameRequest,
  );

  @POST(ApiConstants.changePasswordByUserID)
  Future<ChangePasswordByUserIdResult> changePasswordByUserID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.userId) String userId,
    @Query(ApiConstants.oldPassword) String oldPassword,
    @Query(ApiConstants.newPassword) String newPassword,
  );

  @POST(ApiConstants.getUSerDetailsByUserID)
  Future<LoginResult> getUSerDetailsByUserID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.userId) String userId,
  );

  @POST(ApiConstants.editUser)
  Future<LoginResult> editUser(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() EditUserRequest editUserRequest,
  );

  @POST(ApiConstants.checkDuplicateUserIDAndEmail)
  Future<UserExistResult> checkDuplicateUserIDAndEmail(
      @Query(ApiConstants.emailOrUserID) String emailOrUserID,
      @Query(ApiConstants.type) int type,
      );
}

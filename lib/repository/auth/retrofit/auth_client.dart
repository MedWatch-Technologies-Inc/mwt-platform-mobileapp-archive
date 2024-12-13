import 'package:dio/dio.dart';
import 'package:health_gauge/repository/auth/model/login_result.dart';
import 'package:health_gauge/repository/auth/request/user_registration_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST(ApiConstants.userLogin)
  Future<LoginResult> userLogin(
    @Query(ApiConstants.userName) String userName,
    @Query(ApiConstants.password) String password,
    @Query(ApiConstants.deviceToken) String deviceToken,
  );

  @POST(ApiConstants.userRegistration)
  Future<LoginResult> userRegistration(
      @Body() UserRegistrationRequest userRegistrationRequest);

}

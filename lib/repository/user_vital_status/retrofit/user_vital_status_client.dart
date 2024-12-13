import 'package:dio/dio.dart';
import 'package:health_gauge/repository/user_vital_status/model/get_user_vital_status_result.dart';
import 'package:health_gauge/repository/user_vital_status/model/save_user_vital_status_result.dart';
import 'package:health_gauge/repository/user_vital_status/request/get_user_vital_status_request.dart';
import 'package:health_gauge/repository/user_vital_status/request/save_user_vital_status_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'user_vital_status_client.g.dart';

@RestApi()
abstract class UserVitalStatusClient {
  factory UserVitalStatusClient(Dio dio, {String baseUrl}) =
      _UserVitalStatusClient;

  @POST(ApiConstants.getUserVitalStatus)
  Future<GetUserVitalStatusResult> getUserVitalStatus(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetUserVitalStatusRequest userRegistrationRequest);

  @POST(ApiConstants.saveUserVitalStatus)
  Future<SaveUserVitalStatusResult> saveUserVitalStatus(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() List<SaveUserVitalStatusRequest> dataList);
}

import 'package:dio/dio.dart';
import 'package:health_gauge/repository/dashboard/model/get_dashboard_data_result.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'dashboard_client.g.dart';

@RestApi()
abstract class DashboardClient {
  factory DashboardClient(Dio dio, {String baseUrl}) = _DashboardClient;

  @POST(ApiConstants.getDashboardData)
  Future<GetDashboardDataResult> getPreferenceSettings(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.userID) String userID);
}

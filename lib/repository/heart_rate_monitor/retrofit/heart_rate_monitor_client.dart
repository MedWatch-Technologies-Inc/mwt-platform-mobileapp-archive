import 'package:dio/dio.dart';
import 'package:health_gauge/repository/heart_rate_monitor/model/get_hr_data_response.dart';
import 'package:health_gauge/repository/heart_rate_monitor/model/save_hr_data_response.dart';
import 'package:health_gauge/repository/heart_rate_monitor/request/get_hr_data_request.dart';
import 'package:health_gauge/repository/heart_rate_monitor/request/save_hr_data_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'heart_rate_monitor_client.g.dart';

@RestApi()
abstract class HeartRateMonitorClient {
  factory HeartRateMonitorClient(Dio dio, {String baseUrl}) = _HeartRateMonitorClient;

  @POST(ApiConstants.getHrData)
  Future<GetHrDataResponse> getHrDataList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetHrDataRequest getHrDataRequest);

  @POST(ApiConstants.storeHrData)
  Future<SaveHrDataResponse> storeHrData(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() SaveHrDataRequest saveHrDataRequest);
}

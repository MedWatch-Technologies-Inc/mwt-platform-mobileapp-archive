import 'package:dio/dio.dart';
import 'package:health_gauge/repository/blood_pressure_monitor/model/get_bp_data_response.dart';
import 'package:health_gauge/repository/blood_pressure_monitor/model/save_bp_data_response.dart';
import 'package:health_gauge/repository/blood_pressure_monitor/request/get_bp_data_request.dart';
import 'package:health_gauge/repository/blood_pressure_monitor/request/save_bp_data_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'blood_pressure_monitor_client.g.dart';

@RestApi()
abstract class BloodPressureMonitorClient {
  factory BloodPressureMonitorClient(Dio dio, {String baseUrl}) = _BloodPressureMonitorClient;

  @POST(ApiConstants.getBloodPressureData)
  Future<GetBPDataResponse> getBPDataList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetBPDataRequest getBPDataRequest);

  @POST(ApiConstants.storeBloodPressureData)
  Future<SaveBPDataResponse> storeBPData(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() SaveBPDataRequest saveBPDataRequest);
}

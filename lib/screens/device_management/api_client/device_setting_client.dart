import 'package:dio/dio.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/device_management/model/device_setting_model.dart';
import 'package:health_gauge/screens/device_management/model/get_device_settings_result.dart';
import 'package:health_gauge/screens/device_management/model/m_t_response.dart';
import 'package:retrofit/retrofit.dart';

import 'device_setting_updatData.dart';

part 'device_setting_client.g.dart';

@RestApi()
abstract class DeviceSettingClient {
  factory DeviceSettingClient(Dio dio, {String baseUrl}) = _DeviceSettingClient;

  @GET(ApiConstants.getDeviceSettings)
  Future<GetDeviceSettingResult> fetchDeviceSettings(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.userID) int userID,
  );

  @POST(ApiConstants.getAllLatestMeasurementTimestamp)
  Future<MTResponse> fetchMeasurementTimestamp(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.userID) int userID,
      );

  @POST(ApiConstants.updateDeviceSettings)
  Future<GetDeviceSettingResult> postDeviceSettings(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() UpdateDataRequest updateData,
  );


}

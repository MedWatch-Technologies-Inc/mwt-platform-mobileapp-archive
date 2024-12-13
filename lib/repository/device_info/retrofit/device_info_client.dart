import 'package:dio/dio.dart';
import 'package:health_gauge/repository/device_info/model/store_device_info_result.dart';
import 'package:health_gauge/repository/device_info/request/store_device_info_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'device_info_client.g.dart';

@RestApi()
abstract class DeviceInfoClient {
  factory DeviceInfoClient(Dio dio, {String baseUrl}) = _DeviceInfoClient;

  @POST(ApiConstants.storeDeviceInfo)
  Future<StoreDeviceInfoResult> storeDeviceInfo(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() StoreDeviceInfoRequest storeWeightMeasurementRequest);
}

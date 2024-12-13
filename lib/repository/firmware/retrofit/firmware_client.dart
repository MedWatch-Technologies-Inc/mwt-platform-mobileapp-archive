import 'package:dio/dio.dart';
import 'package:health_gauge/repository/firmware/model/get_firmware_version_list_result.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'firmware_client.g.dart';

@RestApi()
abstract class FirmwareClient {
  factory FirmwareClient(Dio dio, {String baseUrl}) = _FirmwareClient;

  @POST(ApiConstants.getFirmwareVersionList)
  Future<GetFirmwareVersionListResult> getFirmwareVersionList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.pageNumber) int pageNumber,
      @Query(ApiConstants.pageSize) int pageSize);
}

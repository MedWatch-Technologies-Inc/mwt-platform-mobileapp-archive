import 'package:dio/dio.dart';
import 'package:health_gauge/repository/all_measurement_count/model/get_all_measurement_count_result.dart';
import 'package:health_gauge/repository/all_measurement_count/request/get_all_measurement_count_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'all_measurement_count_client.g.dart';


@RestApi()
abstract class AllMeasurementCountClient {
  factory AllMeasurementCountClient(Dio dio, {String baseUrl}) = _AllMeasurementCountClient;

  @POST(ApiConstants.getAllMeasurementCountData)
  Future<GetAllMeasurementCountResult> getPreferenceSettings(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.userID) String userID);

  @POST(ApiConstants.getAllMeasurementCountData)
  Future<GetAllMeasurementCountResult> getAllMeasurementCountData(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetAllMeasurementCountRequest getAllMeasurementCountRequest,
      );


}
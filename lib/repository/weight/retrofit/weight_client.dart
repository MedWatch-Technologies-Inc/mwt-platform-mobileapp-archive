import 'package:dio/dio.dart';
import 'package:health_gauge/repository/weight/model/get_weight_measurement_list_result.dart';
import 'package:health_gauge/repository/weight/model/store_weight_measurement_result.dart';
import 'package:health_gauge/repository/weight/request/get_weight_measurement_list_request.dart';
import 'package:health_gauge/repository/weight/request/store_weight_measurement_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'weight_client.g.dart';

@RestApi()
abstract class WeightClient {
  factory WeightClient(Dio dio, {String baseUrl}) = _WeightClient;

  @POST(ApiConstants.storeWeightMeasurement)
  Future<StoreWeightMeasurementResult> storeWeightMeasurement(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() List<StoreWeightMeasurementRequest> storeWeightMeasurementRequest);

  @POST(ApiConstants.getWeightMeasurementList)
  Future<GetWeightMeasurementListResult> getWeightMeasurementList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetWeightMeasurementListRequest getWeightMeasurementListRequest);
}

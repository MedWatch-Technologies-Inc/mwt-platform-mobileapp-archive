import 'package:dio/dio.dart';
import 'package:health_gauge/repository/measurement/model/delete_estimate_result.dart';
import 'package:health_gauge/repository/measurement/model/estimate_result.dart';
import 'package:health_gauge/repository/measurement/model/get_ecg_ppg_detail_list_result.dart';
import 'package:health_gauge/repository/measurement/model/get_measurement_detail_list_result.dart';
import 'package:health_gauge/repository/measurement/model/set_measurement_unit_result.dart';
import 'package:health_gauge/repository/measurement/request/add_measurement_request.dart';
import 'package:health_gauge/repository/measurement/request/get_ecg_ppg_detail_list_request.dart';
import 'package:health_gauge/repository/measurement/request/get_measurement_detail_list_request.dart';
import 'package:health_gauge/repository/measurement/request/set_measurement_unit_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'client_measurement.g.dart';

@RestApi()
abstract class MeasurementClient {
  factory MeasurementClient(Dio dio, {String baseUrl}) = _MeasurementClient;

  @POST(ApiConstants.getMeasurementEstimate)
  Future<EstimateResult> getMeasurementEstimate(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() AddMeasurementRequest measurementDetails,@CancelRequest() cancelRequest);

  @POST(ApiConstants.getMeasurementDetailList)
  Future<GetMeasurementDetailListResult> getMeasurementDetailList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetMeasurementDetailListRequest getMeasurementDetailListRequest);

  @POST(ApiConstants.getEcgPpgDetailList)
  Future<GetEcgPpgDetailListResult> getEcgPpgDetailList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetEcgPpgDetailListRequest getEcgPpgDetailListRequest);

  @POST(ApiConstants.deleteEstimateDetailByID)
  Future<DeleteEstimateResult> deleteEstimateDetailByID(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.iD) int id);

  @POST(ApiConstants.setMeasurementUnit)
  Future<SetMeasurementUnitResult> setMeasurementUnit(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() SetMeasurementUnitRequest setMeasurementUnitRequest);
}

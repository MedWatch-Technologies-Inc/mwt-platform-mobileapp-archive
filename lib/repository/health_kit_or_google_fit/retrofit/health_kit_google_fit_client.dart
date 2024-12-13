import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:health_gauge/repository/health_kit_or_google_fit/model/save_third_party_data_type_result.dart';
import 'package:health_gauge/repository/health_kit_or_google_fit/request/save_third_party_data_type_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'health_kit_google_fit_client.g.dart';

@RestApi()
abstract class HealthKitGoogleFitClient {
  factory HealthKitGoogleFitClient(Dio dio, {String baseUrl}) =
      _HealthKitGoogleFitClient;

  @POST(ApiConstants.saveThirdPartyDataType)
  Future<SaveThirdPartyDataTypeResult> saveThirdPartyDataType(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() List<SaveThirdPartyDataTypeRequest> dataList);
}

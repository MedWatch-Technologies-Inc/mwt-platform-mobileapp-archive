import 'dart:io';

import 'package:dio/dio.dart';
import 'package:health_gauge/repository/preference/model/get_preference_setting_result.dart';
import 'package:health_gauge/repository/preference/model/store_preference_setting_result.dart';
import 'package:health_gauge/repository/preference/request/get_preference_setting_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'preference_client.g.dart';

@RestApi()
abstract class PreferenceClient {
  factory PreferenceClient(Dio dio, {String baseUrl}) = _PreferenceClient;

  @POST(ApiConstants.getPreferenceSettings)
  Future<GetPreferenceSettingResult> getPreferenceSettings(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetPreferenceSettingRequest storeWeightMeasurementRequest);

  @POST(ApiConstants.storePreferenceSettings)
  Future<StorePreferenceSettingResult> storePreferenceSettings(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Part() String UserID,
      @Part() int CreatedDateTimeStamp,
      @Part() File File);
}

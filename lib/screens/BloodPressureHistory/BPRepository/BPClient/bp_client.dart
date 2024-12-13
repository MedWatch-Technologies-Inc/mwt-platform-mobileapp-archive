import 'package:dio/dio.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_reponse.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_save_response.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPRequest/bp_h_request.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPRequest/bp_save_request.dart';
import 'package:retrofit/retrofit.dart';

part 'bp_client.g.dart';

@RestApi()
abstract class BPClient {
  factory BPClient(Dio dio, {String baseUrl}) = _BPClient;

  @POST(ApiConstants.getBloodPressureData)
  Future<BPHistoryResponse> fetchAllBPHistory(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() BPHistoryRequest getBPDataRequest);

  @POST(ApiConstants.storeBloodPressureData)
  Future<BPSaveResponse> saveBPData(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() BPSaveRequest saveBPDataRequest);
}

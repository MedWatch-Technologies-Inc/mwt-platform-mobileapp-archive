import 'package:dio/dio.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_reponse.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPRequest/bp_h_request.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/HRRequest/hr_request.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/HRResponse/hr_response.dart';
import 'package:retrofit/retrofit.dart';

part 'hr_client.g.dart';

@RestApi()
abstract class HRClient {
  factory HRClient(Dio dio, {String baseUrl}) = _HRClient;

  @POST(ApiConstants.getHrData)
  Future<HRResponse> fetchAllHRData(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() HRRequest hrRequest);
}

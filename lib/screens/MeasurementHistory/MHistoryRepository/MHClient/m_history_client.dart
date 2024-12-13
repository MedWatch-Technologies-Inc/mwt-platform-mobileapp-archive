import 'package:dio/dio.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHRequest/m_ecg_ppg_request.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHRequest/m_history_request.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_ecg_ppg_response.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_response.dart';
import 'package:retrofit/retrofit.dart';

part 'm_history_client.g.dart';

@RestApi()
abstract class MHistoryClient {
  factory MHistoryClient(Dio dio, {String baseUrl}) = _MHistoryClient;

  @POST(ApiConstants.getMeasurementDetailList)
  Future<MHistoryResponse> fetchAllMHistory(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() MHistoryRequest mHistoryRequest,
  );

  @POST(ApiConstants.getEcgPpgDetailList)
  Future<MECGPPGResponse> fetchECGPPGData(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() MECGPPGRequest mECGPPGRequest,
  );
}

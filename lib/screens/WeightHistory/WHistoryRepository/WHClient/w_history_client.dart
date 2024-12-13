import 'package:dio/dio.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/WeightHistory/WHistoryRepository/WHRequest/w_history_request.dart';
import 'package:health_gauge/screens/WeightHistory/WHistoryRepository/WHResponse/w_history_response.dart';
import 'package:retrofit/retrofit.dart';

part 'w_history_client.g.dart';

@RestApi()
abstract class WHistoryClient {
  factory WHistoryClient(Dio dio, {String baseUrl}) = _WHistoryClient;

  @POST(ApiConstants.getWeightMeasurementList)
  Future<WHistoryResponse> fetchAllWHistory(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() WHistoryRequest mHistoryRequest,
  );
}


import 'package:dio/dio.dart';
import 'package:health_gauge/repository/user_vital_status/model/save_user_vital_status_result.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTRequest/ot_h_request.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_model.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_response.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_save_response.dart';
import 'package:retrofit/retrofit.dart';

part 'ot_client.g.dart';

@RestApi()
abstract class OTClient {
  factory OTClient(Dio dio, {String baseUrl}) = _OTClient;

  @POST(ApiConstants.getUserVitalStatus)
  Future<OTHistoryResponse> fetchAllOTHistory(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() OTHistoryRequest getBPDataRequest);

  @POST(ApiConstants.saveUserVitalStatus)
  Future<OTSaveResponse> saveOTData(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() List<OTHistoryModel> dataList);
}

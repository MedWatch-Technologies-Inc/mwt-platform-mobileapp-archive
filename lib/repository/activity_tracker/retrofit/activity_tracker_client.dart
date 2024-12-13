import 'package:dio/dio.dart';
import 'package:health_gauge/repository/activity_tracker/model/get_recognition_activity_list_result.dart';
import 'package:health_gauge/repository/activity_tracker/model/store_recognition_activity_result.dart';
import 'package:health_gauge/repository/activity_tracker/request/get_recognition_activity_list_request.dart';
import 'package:health_gauge/repository/activity_tracker/request/store_recognition_activity_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'activity_tracker_client.g.dart';

@RestApi()
abstract class ActivityTrackerClient {
  factory ActivityTrackerClient(Dio dio, {String baseUrl}) =
      _ActivityTrackerClient;

  @POST(ApiConstants.storeRecognitionActivity)
  Future<StoreRecognitionActivityResult> storeRecognitionActivity(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() StoreRecognitionActivityRequest storeRecognitionActivityRequest);

  @POST(ApiConstants.getRecognitionActivityList)
  Future<GetRecognitionActivityListResult> getRecognitionActivityList(
      @Header(ApiConstants.headerAuthorization)
          String authToken,
      @Body()
          GetRecognitionActivityListRequest getRecognitionActivityListRequest);
}

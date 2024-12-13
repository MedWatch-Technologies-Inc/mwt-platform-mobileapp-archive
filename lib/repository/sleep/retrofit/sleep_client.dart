import 'package:dio/dio.dart';
import 'package:health_gauge/repository/sleep/model/get_sleep_record_detail_list_result.dart';
import 'package:health_gauge/repository/sleep/model/store_sleep_record_detail_result.dart';
import 'package:health_gauge/repository/sleep/request/get_sleep_record_detail_list_request.dart';
import 'package:health_gauge/repository/sleep/request/store_sleep_record_detail_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'sleep_client.g.dart';

@RestApi()
abstract class SleepClient {
  factory SleepClient(Dio dio, {String baseUrl}) = _SleepClient;

  @POST(ApiConstants.getSleepRecordDetailList)
  Future<GetSleepRecordDetailListResult> getSleepRecordDetailList(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetSleepRecordDetailListRequest userRegistrationRequest);

  @POST(ApiConstants.storeSleepRecordDetails)
  Future<StoreSleepRecordDetailResult> storeSleepRecordDetails(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() List<StoreSleepRecordDetailRequest> sleepRecordDetailRequest);
}

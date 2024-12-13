import 'package:dio/dio.dart';
import 'package:health_gauge/repository/motion/model/get_motion_record_list_result.dart';
import 'package:health_gauge/repository/motion/model/store_motion_record_detail_result.dart';
import 'package:health_gauge/repository/motion/request/get_motion_record_list_request.dart';
import 'package:health_gauge/repository/motion/request/store_motion_record_detail_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'motion_client.g.dart';

@RestApi()
abstract class MotionClient {
  factory MotionClient(Dio dio, {String baseUrl}) = _MotionClient;

  @POST(ApiConstants.getMotionRecordList)
  Future<GetMotionRecordListResult> getMotionRecordList(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() GetMotionRecordListRequest storeTagRecordDetailRequest,
  );

  @POST(ApiConstants.storeMotionRecordDetails)
  Future<StoreMotionRecordDetailResult> storeMotionRecordDetails(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() List<StoreMotionRecordDetailRequest> storeTagRecordDetailRequest,
  );
}

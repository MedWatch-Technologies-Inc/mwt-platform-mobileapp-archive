import 'package:dio/dio.dart';
import 'package:health_gauge/repository/tag/model/add_tag_label_result.dart';
import 'package:health_gauge/repository/tag/model/get_tag_label_list_result.dart';
import 'package:health_gauge/repository/tag/model/get_tag_record_list_result.dart';
import 'package:health_gauge/repository/tag/model/store_tag_record_detail_result.dart';
import 'package:health_gauge/repository/tag/request/add_tag_label_request.dart';
import 'package:health_gauge/repository/tag/request/edit_tag_label_request.dart';
import 'package:health_gauge/repository/tag/request/edit_tag_record_detail_request.dart';
import 'package:health_gauge/repository/tag/request/get_tag_label_list_request.dart';
import 'package:health_gauge/repository/tag/request/get_tag_record_list_request.dart';
import 'package:health_gauge/repository/tag/request/store_tag_record_detail_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'tag_client.g.dart';

@RestApi()
abstract class TagClient {
  factory TagClient(Dio dio, {String baseUrl}) = _TagClient;

  @POST(ApiConstants.storeTagRecordDetails)
  Future<StoreTagRecordDetailResult> storeTagRecordDetails(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() StoreTagRecordDetailRequest storeTagRecordDetailRequest,
  );

  @POST(ApiConstants.editTagRecordDetails)
  Future<StoreTagRecordDetailResult> editTagRecordDetails(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() EditTagRecordDetailRequest storeTagRecordDetailRequest,
  );

  @POST(ApiConstants.addTagLabel)
  Future<AddTagLabelResult> addTagLabel(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() AddTagLabelRequest addTagLabelRequest,
  );

  @POST(ApiConstants.editTagLabel)
  Future<AddTagLabelResult> editTagLabel(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() EditTagLabelRequest editTagLabelRequest,
  );

  @POST(ApiConstants.deleteTagLabelByID)
  Future<AddTagLabelResult> deleteTagLabelByID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.tagLabelID) int tagLabelId,
  );

  @POST(ApiConstants.getTagRecordList)
  Future<GetTagRecordListResult> getTagRecordList(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() GetTagRecordListRequest getTagRecordListRequest,
  );

  @POST(ApiConstants.getTagLabelList)
  Future<GetTagLabelListResult> getPreConfigTagLabelList(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() Map<String,dynamic> requestData,
  );

  @POST(ApiConstants.getTagLabelList)
  Future<GetTagLabelListResult> getTagLabelList(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() GetTagLabelListRequest editTagLabelRequest,
  );

  @POST(ApiConstants.deleteTagRecordByID)
  Future<AddTagLabelResult> deleteTagRecordByID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.tagRecordId) int tagRecordId,
  );
}

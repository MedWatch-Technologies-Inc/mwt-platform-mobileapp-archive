import 'package:dio/dio.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/tag/TagHistory/TagRepository/TagRequest/tag_request.dart';
import 'package:health_gauge/screens/tag/TagHistory/TagRepository/TagResponse/tag_response.dart';
import 'package:retrofit/retrofit.dart';

part 'tag_client.g.dart';

@RestApi()
abstract class TClient {
  factory TClient(Dio dio, {String baseUrl}) = _TClient;

  @POST(ApiConstants.getTagRecordList)
  Future<TagResponse> fetchAllTHistory(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() TRequest tRequest,
  );
}

import 'package:dio/dio.dart';
import 'package:health_gauge/screens/tag/TagHistory/TagRepository/TagClient/tag_client.dart';
import 'package:health_gauge/screens/tag/TagHistory/TagRepository/TagRequest/tag_request.dart';
import 'package:health_gauge/screens/tag/TagHistory/TagRepository/TagResponse/tag_response.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class TRepository {
  late TClient _tClient;
  String? baseUrl;

  TRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _tClient = TClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<TagResponse>> fetchAllMHistory(TRequest request) async {
    var response = ApiResponseWrapper<TagResponse>();
    try {
      var result = await _tClient.fetchAllTHistory('${Constants.authToken}', request);
      return response..setData(result);
    } on DioException catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }
}

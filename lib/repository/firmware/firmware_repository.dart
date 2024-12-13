import 'package:dio/dio.dart';
import 'package:health_gauge/repository/firmware/model/get_firmware_version_list_result.dart';
import 'package:health_gauge/repository/firmware/retrofit/firmware_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class FirmwareRepository {
  late FirmwareClient _firmwareClient;

  FirmwareRepository() {
    var dio = ServiceManager.get().getDioClient();
    _firmwareClient = FirmwareClient(dio, baseUrl: Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetFirmwareVersionListResult>>
      getFirmwareVersionList(int pageNumber, int pageSize) async {
    var response = ApiResponseWrapper<GetFirmwareVersionListResult>();
    try {
      return response
        ..setData(await _firmwareClient.getFirmwareVersionList(
            '${Constants.authToken}', pageNumber, pageSize));
    } on DioError catch (error, stacktrace) {
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

import 'package:dio/dio.dart';
import 'package:health_gauge/repository/device_info/model/store_device_info_result.dart';
import 'package:health_gauge/repository/device_info/request/store_device_info_request.dart';
import 'package:health_gauge/repository/device_info/retrofit/device_info_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class DeviceInfoRepository {
  late DeviceInfoClient _deviceInfoClient;

  DeviceInfoRepository() {
    var dio = ServiceManager.get().getDioClient();
    _deviceInfoClient = DeviceInfoClient(dio, baseUrl: Constants.baseUrl);
  }

  Future<ApiResponseWrapper<StoreDeviceInfoResult>> storeDeviceInfo(
      StoreDeviceInfoRequest request) async {
    var response = ApiResponseWrapper<StoreDeviceInfoResult>();
    try {
      return response
        ..setData(await _deviceInfoClient.storeDeviceInfo(
            '${Constants.authToken}', request));
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

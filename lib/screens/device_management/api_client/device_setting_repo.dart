import 'package:dio/dio.dart';
import 'package:health_gauge/screens/device_management/api_client/device_setting_client.dart';
import 'package:health_gauge/screens/device_management/model/get_device_settings_result.dart';
import 'package:health_gauge/screens/device_management/model/m_t_response.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

import 'device_setting_updatData.dart';

class DeviceSettingRepo{
  late DeviceSettingClient _deviceClient;
  String? baseUrl;

  DeviceSettingRepo({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _deviceClient = DeviceSettingClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetDeviceSettingResult>> fetchDeviceSettings(int userID) async {
    var response = ApiResponseWrapper<GetDeviceSettingResult>();
    try {
      print('authToken :: ${Constants.authToken}');
      return response
        ..setData(await _deviceClient.fetchDeviceSettings('${Constants.authToken}', userID));
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

  Future<ApiResponseWrapper<MTResponse>> fetchMeasurementTimestamp(int userID) async {
    var response = ApiResponseWrapper<MTResponse>();
    try {
      print('authToken :: ${Constants.authToken}');
      return response
        ..setData(await _deviceClient.fetchMeasurementTimestamp('${Constants.authToken}', userID));
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

  Future<ApiResponseWrapper<GetDeviceSettingResult>> postDeviceSettings(int userID, UpdateDataRequest request) async {
    var response = ApiResponseWrapper<GetDeviceSettingResult>();
    try {
      print('authToken :: ${Constants.authToken}');
      return response
        ..setData(await _deviceClient.postDeviceSettings('${Constants.authToken}', request));
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
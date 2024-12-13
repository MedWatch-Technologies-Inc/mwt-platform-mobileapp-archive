import 'package:dio/dio.dart';
import 'package:health_gauge/repository/motion/model/get_motion_record_list_result.dart';
import 'package:health_gauge/repository/motion/model/store_motion_record_detail_result.dart';
import 'package:health_gauge/repository/motion/request/get_motion_record_list_request.dart';
import 'package:health_gauge/repository/motion/request/store_motion_record_detail_request.dart';
import 'package:health_gauge/repository/motion/retrofit/motion_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class MotionRepository {
  late MotionClient _motionClient;
  String? baseUrl;

  MotionRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _motionClient = MotionClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetMotionRecordListResult>> getMotionRecordList(
      GetMotionRecordListRequest request) async {
    var response = ApiResponseWrapper<GetMotionRecordListResult>();
    try {
      return response
        ..setData(await _motionClient.getMotionRecordList(
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

  Future<ApiResponseWrapper<StoreMotionRecordDetailResult>>
      storeMotionRecordDetails(List<StoreMotionRecordDetailRequest> request) async {
    var response = ApiResponseWrapper<StoreMotionRecordDetailResult>();
    try {
      return response
        ..setData(await _motionClient.storeMotionRecordDetails(
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

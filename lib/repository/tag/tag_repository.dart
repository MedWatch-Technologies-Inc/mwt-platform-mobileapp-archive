import 'dart:convert';
import 'dart:developer';

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
import 'package:health_gauge/repository/tag/retrofit/tag_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class TagRepository {
  late TagClient _tagClient;
  String? baseUrl;

  TagRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _tagClient = TagClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<StoreTagRecordDetailResult>> storeTagRecordDetails(
      StoreTagRecordDetailRequest request) async {
    var response = ApiResponseWrapper<StoreTagRecordDetailResult>();
    try {
      print('AddTag_body_Data ${request.toJson()}    ${Constants.authToken}');
      return response
        ..setData(await _tagClient.storeTagRecordDetails('${Constants.authToken}', request));
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

  Future<ApiResponseWrapper<StoreTagRecordDetailResult>> editTagRecordDetails(
      EditTagRecordDetailRequest request) async {
    var response = ApiResponseWrapper<StoreTagRecordDetailResult>();
    try {
      print('EditTag_body_Data ${request.toJson()}    ${Constants.authToken}');

      return response
        ..setData(await _tagClient.editTagRecordDetails('${Constants.authToken}', request));
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

  Future<ApiResponseWrapper<AddTagLabelResult>> addTagLabel(AddTagLabelRequest request) async {
    var response = ApiResponseWrapper<AddTagLabelResult>();
    print('add_tag_lable');
    try {
      return response..setData(await _tagClient.addTagLabel('${Constants.authToken}', request));
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

  Future<ApiResponseWrapper<AddTagLabelResult>> editTagLabel(EditTagLabelRequest request) async {
    var response = ApiResponseWrapper<AddTagLabelResult>();
    print('edit_tag_lable');
    try {
      return response..setData(await _tagClient.editTagLabel('${Constants.authToken}', request));
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

  Future<ApiResponseWrapper<AddTagLabelResult>> deleteTagLabelByID(int tagId) async {
    var response = ApiResponseWrapper<AddTagLabelResult>();
    try {
      return response
        ..setData(await _tagClient.deleteTagLabelByID('${Constants.authToken}', tagId));
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

  Future<ApiResponseWrapper<GetTagRecordListResult>> getTagRecordList(
      GetTagRecordListRequest request) async {
    var response = ApiResponseWrapper<GetTagRecordListResult>();
    try {
      return response
        ..setData(await _tagClient.getTagRecordList('${Constants.authToken}', request));
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

  Future<ApiResponseWrapper<GetTagLabelListResult>> getPreConfigTagLabelList(
      Map<String, dynamic> request) async {
    var response = ApiResponseWrapper<GetTagLabelListResult>();
    try {
      return response
        ..setData(
          await _tagClient.getPreConfigTagLabelList('${Constants.authToken}', request),
        );
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

  Future<ApiResponseWrapper<GetTagLabelListResult>> getTagLabelList(
      GetTagLabelListRequest request) async {
    var response = ApiResponseWrapper<GetTagLabelListResult>();
    log('getEstimate_ : ${request.toJson()}');
    try {
      return response..setData(await _tagClient.getTagLabelList('${Constants.authToken}', request));
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

  Future<ApiResponseWrapper<AddTagLabelResult>> deleteTagRecordByID(int tagId) async {
    var response = ApiResponseWrapper<AddTagLabelResult>();
    try {
      return response
        ..setData(await _tagClient.deleteTagRecordByID('${Constants.authToken}', tagId));
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

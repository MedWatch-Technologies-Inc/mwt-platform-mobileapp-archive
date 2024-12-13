import 'dart:io';

import 'package:dio/dio.dart';
import 'package:health_gauge/repository/library/model/fetch_library_event_result.dart';
import 'package:health_gauge/repository/library/model/library_create_folder_event_result.dart';
import 'package:health_gauge/repository/library/model/save_and_update_shared_with_result.dart';
import 'package:health_gauge/repository/library/request/fetch_library_event_request.dart';
import 'package:health_gauge/repository/library/request/library_create_folder_event_request.dart';
import 'package:health_gauge/repository/library/request/save_and_update_shared_with_request.dart';
import 'package:health_gauge/repository/library/request/update_linked_access_event_request.dart';
import 'package:health_gauge/repository/library/request/upload_file_into_drive_event_request.dart';
import 'package:health_gauge/repository/library/retrofit/library_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class LibraryRepository {
  late LibraryClient _libraryClient;
  String? baseUrl;

  LibraryRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _libraryClient = LibraryClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<FetchLibraryEventResult>> getMyDriveListByUserId(
      FetchLibraryEventRequest request) async {
    var response = ApiResponseWrapper<FetchLibraryEventResult>();
    try {
      var result = await _libraryClient.getMyDriveListByUserId(
          '${Constants.authToken}', request.userID!, request.libraryID!);
      return response..setData(result);
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<FetchLibraryEventResult>> sharedWithByUserID(
      FetchLibraryEventRequest request) async {
    var response = ApiResponseWrapper<FetchLibraryEventResult>();
    try {
      return response
        ..setData(await _libraryClient.sharedWithByUserID(
            '${Constants.authToken}', request.userID!));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<FetchLibraryEventResult>> libraryBinListByUserID(
      FetchLibraryEventRequest request) async {
    var response = ApiResponseWrapper<FetchLibraryEventResult>();
    try {
      return response
        ..setData(await _libraryClient.libraryBinListByUserID(
            '${Constants.authToken}', request.userID!, request.libraryID!));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<LibraryCreateFolderEventResult>> createFolder(
      LibraryCreateFolderEventRequest request) async {
    var response = ApiResponseWrapper<LibraryCreateFolderEventResult>();
    try {
      return response
        ..setData(await _libraryClient.createFolder(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<SaveAndUpdateSharedWithResult>> deleteLibraryByID(
      FetchLibraryEventRequest request) async {
    var response = ApiResponseWrapper<SaveAndUpdateSharedWithResult>();
    try {
      return response
        ..setData(await _libraryClient.deleteLibraryByID(
            '${Constants.authToken}', request.userID!, request.libraryID!));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<SaveAndUpdateSharedWithResult>>
      deleteLibraryPermanentlyByID(FetchLibraryEventRequest request) async {
    var response = ApiResponseWrapper<SaveAndUpdateSharedWithResult>();
    try {
      return response
        ..setData(await _libraryClient.deleteLibraryPermanentlyByID(
            '${Constants.authToken}', request.userID!, request.libraryID!));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  // upload

  Future<ApiResponseWrapper<FetchLibraryEventResult>> uploadFileIntoDrive(
      UploadFileIntoDriveEventRequest request) async {
    var response = ApiResponseWrapper<FetchLibraryEventResult>();
    try {
      return response
        ..setData(await _libraryClient.uploadFileIntoDrive(
            '${Constants.authToken}',
            request.userID!,
            File(request.uploadFile!),
            request.libraryID!,
            request.createdDateTimeStamp!
        ));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<FetchLibraryEventResult>> updateLinkedAccess(
      UpdateLinkedAccessEventRequest request) async {
    var response = ApiResponseWrapper<FetchLibraryEventResult>();
    try {
      return response
        ..setData(await _libraryClient.updateLinkedAccess(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<SaveAndUpdateSharedWithResult>> moveDrive(
      FetchLibraryEventRequest request) async {
    var response = ApiResponseWrapper<SaveAndUpdateSharedWithResult>();
    try {
      return response
        ..setData(await _libraryClient.moveDrive(
            '${Constants.authToken}', request.userID!, request.libraryID!));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<SaveAndUpdateSharedWithResult>> deleteShared(
      FetchLibraryEventRequest request) async {
    var response = ApiResponseWrapper<SaveAndUpdateSharedWithResult>();
    try {
      return response
        ..setData(await _libraryClient.deleteShared(
            '${Constants.authToken}', request.userID!, request.libraryID!));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<SaveAndUpdateSharedWithResult>>
      saveAndUpdateSharedWith(SaveAndUpdateSharedWithRequest request) async {
    var response = ApiResponseWrapper<SaveAndUpdateSharedWithResult>();
    try {
      return response
        ..setData(await _libraryClient.saveAndUpdateSharedWith(
            '${Constants.authToken}', request));
    } on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'dio error', message: error.toString());
      LoggingService().printLog(tag: 'dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'api exception', message: exception.toString());
      LoggingService().printLog(tag: 'api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }
}

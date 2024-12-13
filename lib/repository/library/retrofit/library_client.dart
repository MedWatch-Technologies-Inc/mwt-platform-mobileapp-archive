import 'dart:io';

import 'package:dio/dio.dart';
import 'package:health_gauge/repository/library/model/fetch_library_event_result.dart';
import 'package:health_gauge/repository/library/model/library_create_folder_event_result.dart';
import 'package:health_gauge/repository/library/model/save_and_update_shared_with_result.dart';
import 'package:health_gauge/repository/library/request/library_create_folder_event_request.dart';
import 'package:health_gauge/repository/library/request/save_and_update_shared_with_request.dart';
import 'package:health_gauge/repository/library/request/update_linked_access_event_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'library_client.g.dart';

@RestApi()
abstract class LibraryClient {
  factory LibraryClient(Dio dio, {String baseUrl}) = _LibraryClient;

  @POST(ApiConstants.libraryMyDriveListByUserID)
  Future<FetchLibraryEventResult> getMyDriveListByUserId(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.userID) String userId,
      @Query(ApiConstants.libraryID) String libraryId);

  @POST(ApiConstants.sharedWithByUserID)
  Future<FetchLibraryEventResult> sharedWithByUserID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.userID) String userId,
  );

  @POST(ApiConstants.libraryBinListByUserID)
  Future<FetchLibraryEventResult> libraryBinListByUserID(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.userID) String userId,
      @Query(ApiConstants.libraryID) String libraryId);

  @POST(ApiConstants.createFolder)
  Future<LibraryCreateFolderEventResult> createFolder(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() LibraryCreateFolderEventRequest libraryCreateFolderEventRequest);

  @POST(ApiConstants.deleteLibraryByID)
  Future<SaveAndUpdateSharedWithResult> deleteLibraryByID(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.userID) String userId,
      @Query(ApiConstants.libraryID) String libraryId);

  @POST(ApiConstants.deleteLibraryPermanentlyByID)
  Future<SaveAndUpdateSharedWithResult> deleteLibraryPermanentlyByID(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.userID) String userId,
      @Query(ApiConstants.libraryID) String libraryId);

  @POST(ApiConstants.updateLinkedAccess)
  Future<FetchLibraryEventResult> updateLinkedAccess(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() UpdateLinkedAccessEventRequest updateLinkedAccessEventRequest);

  @POST(ApiConstants.uploadFileIntoDrive)
  @MultiPart()
  Future<FetchLibraryEventResult> uploadFileIntoDrive(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Part() int UserID,
      @Part() File UploadFile,
      @Part() int LibraryID,
      @Part(name: 'CreatedDateTimeStamp') int currentDateTimeStamp
      );

  @POST(ApiConstants.moveDrive)
  Future<SaveAndUpdateSharedWithResult> moveDrive(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.userID) String userId,
      @Query(ApiConstants.libraryID) String libraryId);

  @POST(ApiConstants.deleteShared)
  Future<SaveAndUpdateSharedWithResult> deleteShared(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Query(ApiConstants.userID) String userId,
      @Query(ApiConstants.libraryID) String libraryId);

  @POST(ApiConstants.saveAndUpdateSharedWith)
  Future<SaveAndUpdateSharedWithResult> saveAndUpdateSharedWith(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() SaveAndUpdateSharedWithRequest saveAndUpdateSharedWithRequest);
}

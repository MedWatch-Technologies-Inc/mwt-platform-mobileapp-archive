import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/library_models/delete_folder_model.dart';
import 'package:health_gauge/models/library_models/library_detail_model.dart';
import 'package:health_gauge/models/library_models/library_list.dart';
import 'package:health_gauge/repository/library/library_repository.dart';
import 'package:health_gauge/repository/library/request/fetch_library_event_request.dart';
import 'package:health_gauge/repository/library/request/library_create_folder_event_request.dart';
import 'package:health_gauge/repository/library/request/save_and_update_shared_with_request.dart';
import 'package:health_gauge/repository/library/request/update_linked_access_event_request.dart';
import 'package:health_gauge/repository/library/request/upload_file_into_drive_event_request.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_event.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_state.dart';
import 'package:health_gauge/utils/constants.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryIsLoadingState());

  @override
  Stream<LibraryState> mapEventToState(LibraryEvent event) async* {
    if (event is FetchLibraryEvent) {
      print('--------Inside Fetch Library Event--------');
      print(event.pageId);
      print(event.libraryId);
      print(event.userId);
      // fetching data from api
      var internetAvailable = await Constants.isInternetAvailable();
      if (internetAvailable) {
        var requestBody;
        LibraryDetailModel? libraryDetailModel;

        yield LibraryIsLoadingState();
        if (event.pageId == 1) {
          requestBody = {
            'UserID': event.userId.toString(),
            'LibraryID': event.libraryId.toString(),
          };
          final estimatedResult = await LibraryRepository()
              .getMyDriveListByUserId(FetchLibraryEventRequest(
            userID: event.userId.toString(),
            libraryID: event.libraryId.toString(),
          ));
          if (estimatedResult.hasData) {
            yield LibraryIsLoadedState(
              libraryDetailModel: LibraryDetailModel(
                result: estimatedResult.getData!.result!,
                response: estimatedResult.getData!.response!,
                data: estimatedResult.getData!.data != null
                    ? estimatedResult.getData!.data!
                        .map((e) => LibraryList.fromJson(e.toJson()))
                        .toList()
                    : [],
              ),
            );
          } else {}
          // libraryDetailModel = await LibraryGetDataListApi().callApi(
          //     Constants.inboxBaseUrl + 'LibraryMyDriveListByUserID',
          //     requestBody);
        } else if (event.pageId == 2) {
          requestBody = {
            'UserID': event.userId.toString(),
          };
          final estimatedResult = await LibraryRepository()
              .sharedWithByUserID(FetchLibraryEventRequest(
            userID: event.userId.toString(),
          ));
          if (estimatedResult.hasData) {
            yield LibraryIsLoadedState(
              libraryDetailModel: LibraryDetailModel(
                result: estimatedResult.getData!.result!,
                response: estimatedResult.getData!.response!,
                data: estimatedResult.getData!.data != null
                    ? estimatedResult.getData!.data!
                        .map((e) => LibraryList.fromJson(e.toJson()))
                        .toList()
                    : [],
              ),
            );
          } else {}
          // libraryDetailModel = await LibraryGetDataListApi().callApi(
          //     Constants.inboxBaseUrl + 'SharedWithByUserID', requestBody);
        } else if (event.pageId == 3) {
          requestBody = {
            'UserID': event.userId.toString(),
            'LibraryID': event.libraryId.toString(),
          };
          final estimatedResult = await LibraryRepository()
              .libraryBinListByUserID(FetchLibraryEventRequest(
            userID: event.userId.toString(),
            libraryID: event.libraryId.toString(),
          ));
          if (estimatedResult.hasData) {
            yield LibraryIsLoadedState(
              libraryDetailModel: LibraryDetailModel(
                result: estimatedResult.getData!.result!,
                response: estimatedResult.getData!.response!,
                data: estimatedResult.getData!.data != null
                    ? estimatedResult.getData!.data!
                        .map((e) => LibraryList.fromJson(e.toJson()))
                        .toList()
                    : [],
              ),
            );
          } else {}
          // libraryDetailModel = await LibraryGetDataListApi().callApi(
          //     Constants.inboxBaseUrl + 'LibraryBinListByUserID', requestBody);
        }
        // yield LibraryIsLoadedState(libraryDetailModel: libraryDetailModel);
      }
    }
    /////
    else if (event is LibraryCreateFolderEvent) {
      print('--------Inside Library Create Folder Event--------');
      print(event.folderName);
      print(event.libraryId);
      print(event.userId);
      print(event.folderPath);

      var requestBody = {
        'UserID': event.userId,
        'LibraryID': event.libraryId,
        'FolderName': event.folderName,
        'FolderPath': event.folderPath
      };
      var internetAvailable = await Constants.isInternetAvailable();
      if (internetAvailable) {
        final result = await LibraryRepository()
            .createFolder(LibraryCreateFolderEventRequest(
          userID: event.userId,
          libraryID: event.libraryId,
          folderName: event.folderName,
          folderPath: event.folderPath,
          createdDateTimeStamp: DateTime.now().millisecondsSinceEpoch
        ));
        print(result);
        // var createFolderModel = await LibraryCreateFolder().callApi(
        //   Constants.inboxBaseUrl + 'CreateFolder',
        //   jsonEncode(requestBody),
        // );
        //
        // print(createFolderModel!.result);
        // print(createFolderModel.response);
        // print(createFolderModel.message);
        // print(createFolderModel.iD);

        yield LibraryFolderCreateSuccessState();

        var request = {
          'UserID': event.userId.toString(),
          'LibraryID': event.libraryId.toString(),
        };

        yield LibraryIsLoadingState();

        final estimatedResult = await LibraryRepository()
            .getMyDriveListByUserId(FetchLibraryEventRequest(
          userID: event.userId.toString(),
          libraryID: event.libraryId.toString(),
        ));
        if (estimatedResult.hasData) {
          yield LibraryIsLoadedState(
            libraryDetailModel: LibraryDetailModel(
              result: estimatedResult.getData!.result!,
              response: estimatedResult.getData!.response!,
              data: estimatedResult.getData!.data != null
                  ? estimatedResult.getData!.data!
                      .map((e) => LibraryList.fromJson(e.toJson()))
                      .toList()
                  : [],
            ),
          );
        } else {}
        // var libraryDetailModel = await LibraryGetDataListApi().callApi(
        //     Constants.inboxBaseUrl + 'LibraryMyDriveListByUserID', request);
        // yield LibraryIsLoadedState(libraryDetailModel: libraryDetailModel);
      }
    }
    /////
    else if (event is LibraryDeleteFolderEvent) {
      print('--------Inside Library Delete Folder Event--------');
      print(event.deleteLibraryId);
      print(event.libraryId);
      print(event.userId);

      var requestBody = {
        'UserID': event.userId.toString(),
        'LibraryID': event.deleteLibraryId.toString(),
      };
      var internetAvailable = await Constants.isInternetAvailable();
      if (internetAvailable) {
        final result = await LibraryRepository().deleteLibraryByID(
            FetchLibraryEventRequest(
                userID: event.userId.toString(),
                libraryID: event.deleteLibraryId.toString()));
        if (result.hasData) {
          if (result.getData!.result!) {
            yield LibraryFolderDeleteSuccessState(DeleteFolderModel(
              response: result.getData!.response!,
              result: result.getData!.result!,
              iD: result.getData!.iD!,
              message: result.getData!.message!,
            ));
          } else {
            yield LibraryFolderDeleteUnsuccessfulState();
          }
        } else {
          yield LibraryFolderDeleteUnsuccessfulState();
        }
        // var deleteFolderModel = await LibraryDeleteFolder().callApi(
        //   Constants.inboxBaseUrl + 'DeleteLibraryByID',
        //   requestBody,
        // );
        //
        // if (deleteFolderModel!.result!) {
        //   yield LibraryFolderDeleteSuccessState(deleteFolderModel);
        // } else {
        //   yield LibraryFolderDeleteUnsuccessfulState();
        // }
      }
    }
    ////
    else if (event is LibraryDeleteFolderPermanentlyEvent) {
      print('--------Inside Library Delete Folder Permanently Event--------');
      print(event.deleteLibraryId);
      print(event.libraryId);
      print(event.userId);

      var requestBody = {
        'UserID': event.userId.toString(),
        'LibraryID': event.deleteLibraryId.toString(),
      };
      var internetAvailable = await Constants.isInternetAvailable();
      if (internetAvailable) {
        final result = await LibraryRepository()
            .deleteLibraryPermanentlyByID(FetchLibraryEventRequest(
          userID: event.userId.toString(),
          libraryID: event.deleteLibraryId.toString(),
        ));
        if (result.hasData) {
          if (result.getData!.result!) {
            yield LibraryFolderDeleteSuccessState(DeleteFolderModel(
              response: result.getData!.response!,
              result: result.getData!.result!,
              iD: result.getData!.iD!,
              message: result.getData!.message!,
            ));
          } else {
            yield LibraryFolderDeleteUnsuccessfulState();
          }
        } else {
          yield LibraryFolderDeleteUnsuccessfulState();
        }
        // var deleteFolderModel = await LibraryDeleteFolder().callApi(
        //   Constants.inboxBaseUrl + 'DeleteLibraryPermanentlyByID',
        //   requestBody,
        // );
        // if (deleteFolderModel!.result!) {
        //   yield LibraryFolderDeleteSuccessState(deleteFolderModel);
        // } else {
        //   yield LibraryFolderDeleteUnsuccessfulState();
        // }
      }
    } else if (event is LibraryUploadFolderEvent) {
      var upload = false;

      var internetAvailable = await Constants.isInternetAvailable();
      if (internetAvailable) {
        for (var i = 0; i < event.filePath!.length; i++) {
          var requestBody = {
            'UserID': int.parse(event.userId!),
            'LibraryID': event.libraryId,
            'UploadFile': event.filePath![i].path,
          };
          final result = await LibraryRepository().uploadFileIntoDrive(
              UploadFileIntoDriveEventRequest(
                  userID: int.parse(event.userId!),
                  libraryID: event.libraryId,
                  uploadFile: event.filePath![i].path,
                createdDateTimeStamp: DateTime.now().millisecondsSinceEpoch
              ));
          if (result.hasData) {
            if (result.getData!.result!) {
              upload = true;
              break;
            } else {
              // yield LibraryFolderDeleteUnsuccessfulState();
            }
          } else {
            // yield LibraryFolderDeleteUnsuccessfulState();
          }
          // var createFolderModel = await LibraryUploadFile().uploadFile(
          //     Constants.inboxBaseUrl + 'UploadFileIntoDrive', requestBody);
          // if (createFolderModel != null &&
          //     createFolderModel.result != null &&
          //     !createFolderModel.result!) {
          //   upload = true;
          //   break;
          // }
        }

        if (upload) {
          yield LibraryFolderUploadSuccessfulState();
        } else {
          yield LibraryFolderUploadUnsuccessfulState();
        }
        var request = {
          'UserID': event.userId.toString(),
          'LibraryID': event.libraryId.toString(),
        };

        final estimatedResult = await LibraryRepository()
            .getMyDriveListByUserId(FetchLibraryEventRequest(
          userID: event.userId.toString(),
          libraryID: event.libraryId.toString(),
        ));
        if (estimatedResult.hasData) {
          yield LibraryIsLoadedState(
            libraryDetailModel: LibraryDetailModel(
              result: estimatedResult.getData!.result!,
              response: estimatedResult.getData!.response!,
              data: estimatedResult.getData!.data != null
                  ? estimatedResult.getData!.data!
                      .map((e) => LibraryList.fromJson(e.toJson()))
                      .toList()
                  : [],
            ),
          );
        } else {}

        // var libraryDetailModel = await LibraryGetDataListApi().callApi(
        //     Constants.inboxBaseUrl + 'LibraryMyDriveListByUserID', request);
        // yield LibraryIsLoadedState(libraryDetailModel: libraryDetailModel);
      }
    }

    if (event is LibraryChangeLinkAccessSpecifier) {
      var requestBody = {
        'UserID': event.userId,
        'FKLirabaryID': event.libraryId,
        'OptionCopyLinkAccess': event.accessSpecifier,
      };
      var internetAvailable = await Constants.isInternetAvailable();
      if (internetAvailable) {
        final result = await LibraryRepository()
            .updateLinkedAccess(UpdateLinkedAccessEventRequest(
          userID: event.userId,
          fKLirabaryID: event.libraryId,
          optionCopyLinkAccess: event.accessSpecifier,
        ));
        if (result.hasData) {
          if (result.getData!.result!) {
            yield LinkAccessChangedState();
          } else {
            // yield LibraryFolderDeleteUnsuccessfulState();
          }
        } else {
          // yield LibraryFolderDeleteUnsuccessfulState();
        }
        // var libraryDetailModel = await LibraryGetLinkedAccess().callApi(
        //     Constants.inboxBaseUrl + 'UpdateLinkedAccess',
        //     jsonEncode(requestBody));
        // if (libraryDetailModel!.result!) {
        //   yield LinkAccessChangedState();
        // }
      }
    }

    if (event is LibraryRestoreEvent) {
      print('Restore folder/file ');
      var requestBody = {
        'UserID': event.userId.toString(),
        'LibraryID': event.libraryId.toString(),
      };
      var internetAvailable = await Constants.isInternetAvailable();
      if (internetAvailable) {
        final result =
            await LibraryRepository().moveDrive(FetchLibraryEventRequest(
          userID: event.userId.toString(),
          libraryID: event.libraryId.toString(),
        ));
        if (result.hasData) {
          if (result.getData!.result!) {
            yield RestoredSuccessState(DeleteFolderModel(
              response: result.getData!.response!,
              result: result.getData!.result!,
              iD: result.getData!.iD!,
              message: result.getData!.message!,
            ));
          } else {
            // yield LibraryFolderDeleteUnsuccessfulState();
          }
        } else {
          // yield LibraryFolderDeleteUnsuccessfulState();
        }
        // var deleteFolderModel = await LibraryRestoreApi()
        //     .callApi(Constants.inboxBaseUrl + 'MoveDrive', requestBody);
        // if (deleteFolderModel!.result!) {
        //   yield RestoredSuccessState(deleteFolderModel);
        // }
      }
    }

    if (event is DeleteSharedEvent) {
      print(event.deleteLibraryId);
      print(event.libraryId);
      print(event.userId);

      var requestBody = {
        'UserID': event.userId.toString(),
        'LibraryID': event.deleteLibraryId.toString(),
      };
      var internetAvailable = await Constants.isInternetAvailable();
      if (internetAvailable) {
        final result =
            await LibraryRepository().deleteShared(FetchLibraryEventRequest(
          userID: event.userId.toString(),
          libraryID: event.deleteLibraryId.toString(),
        ));
        if (result.hasData) {
          if (result.getData!.result!) {
            yield LibraryFolderDeleteSuccessState(DeleteFolderModel(
              response: result.getData!.response!,
              result: result.getData!.result!,
              iD: result.getData!.iD!,
              message: result.getData!.message!,
            ));
          } else {
            yield LibraryFolderDeleteUnsuccessfulState();
          }
        } else {
          yield LibraryFolderDeleteUnsuccessfulState();
        }
        // var deleteFolderModel = await LibraryDeleteFolder().callApi(
        //   Constants.inboxBaseUrl + 'DeleteShared',
        //   requestBody,
        // );
        // if (deleteFolderModel!.result!) {
        //   yield LibraryFolderDeleteSuccessState(deleteFolderModel);
        // } else {
        //   yield LibraryFolderDeleteUnsuccessfulState();
        // }
      }
    }

    if (event is SaveAndUpdateSharedWith) {
      yield SharingWithUserState();
      var requestBody = {
        'SharedMessage': event.sharedMessage,
        'UserID': event.userID,
        'FKLirabaryID': event.fKLirabaryID,
        'FKSharedUserID': event.fKSharedUserID,
        'Accessspicefire': event.accessspicefire,
        'SavedAccessID': event.savedAccessID,
        'SavedAccessChanged': event.savedAccessChanged
      };

      var internetAvailable = await Constants.isInternetAvailable();
      if (internetAvailable) {
        final result = await LibraryRepository()
            .saveAndUpdateSharedWith(SaveAndUpdateSharedWithRequest(
          sharedMessage: event.sharedMessage,
          userID: event.userID,
          fKLirabaryID: event.fKLirabaryID,
          fKSharedUserID: event.fKSharedUserID,
          accessspicefire: event.accessspicefire,
          savedAccessID: event.savedAccessID,
          savedAccessChanged: event.savedAccessChanged,
          sharedDateTimeStamp: DateTime.now().millisecondsSinceEpoch
        ));
        if (result.hasData) {
          if (result.getData!.result!) {
            yield SaveAndUpdateSharedWithSuccessState();
          } else {
            yield SaveAndUpdateSharedWithUnSuccessState();
          }
        } else {
          yield SaveAndUpdateSharedWithUnSuccessState();
        }
        // var deleteFolderModel = await LibraryDeleteFolder().callApi(
        //   Constants.inboxBaseUrl + 'SaveandUpdateSharedWith',
        //   jsonEncode(requestBody),
        // );
        //
        // if (deleteFolderModel!.result!) {
        //   yield SaveAndUpdateSharedWithSuccessState();
        // } else {
        //   yield SaveAndUpdateSharedWithUnSuccessState();
        // }
      }
    }
  }
}

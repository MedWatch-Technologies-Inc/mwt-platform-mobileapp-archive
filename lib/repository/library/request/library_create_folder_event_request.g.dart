// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_create_folder_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryCreateFolderEventRequest _$LibraryCreateFolderEventRequestFromJson(
        Map json) =>
    LibraryCreateFolderEventRequest(
      userID: json['UserID'] as String?,
      libraryID: json['LibraryID'] as int?,
      folderName: json['FolderName'] as String?,
      folderPath: json['FolderPath'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as int?,
    );

Map<String, dynamic> _$LibraryCreateFolderEventRequestToJson(
        LibraryCreateFolderEventRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'LibraryID': instance.libraryID,
      'FolderName': instance.folderName,
      'FolderPath': instance.folderPath,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

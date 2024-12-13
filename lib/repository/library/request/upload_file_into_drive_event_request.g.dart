// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_file_into_drive_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadFileIntoDriveEventRequest _$UploadFileIntoDriveEventRequestFromJson(
        Map json) =>
    UploadFileIntoDriveEventRequest(
      userID: json['UserID'] as int?,
      libraryID: json['LibraryID'] as int?,
      uploadFile: json['UploadFile'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as int?,
    );

Map<String, dynamic> _$UploadFileIntoDriveEventRequestToJson(
        UploadFileIntoDriveEventRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'LibraryID': instance.libraryID,
      'UploadFile': instance.uploadFile,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

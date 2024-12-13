// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_library_event_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchLibraryEventResult _$FetchLibraryEventResultFromJson(Map json) =>
    FetchLibraryEventResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => FetchLibraryEventData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$FetchLibraryEventResultToJson(
        FetchLibraryEventResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

FetchLibraryEventData _$FetchLibraryEventDataFromJson(Map json) =>
    FetchLibraryEventData(
      libraryID: json['LibraryID'] as int?,
      virtualFilePath: json['VirtualFilePath'] as String?,
      physicalFilePath: json['PhysicalFilePath'] as String?,
      createdDateTime: json['CreatedDateTime'] as String?,
      parentID: json['ParentID'] as int?,
      fileSize: json['FileSize'] as String?,
      isFolder: json['IsFolder'] as bool?,
    )..createdDateTimeStamp = json['CreatedDateTimeStamp'] as String?;

Map<String, dynamic> _$FetchLibraryEventDataToJson(
        FetchLibraryEventData instance) =>
    <String, dynamic>{
      'LibraryID': instance.libraryID,
      'VirtualFilePath': instance.virtualFilePath,
      'PhysicalFilePath': instance.physicalFilePath,
      'CreatedDateTime': instance.createdDateTime,
      'ParentID': instance.parentID,
      'FileSize': instance.fileSize,
      'IsFolder': instance.isFolder,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

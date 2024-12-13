// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_create_folder_event_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryCreateFolderEventResult _$LibraryCreateFolderEventResultFromJson(
        Map json) =>
    LibraryCreateFolderEventResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
      iD: json['ID'] as int?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$LibraryCreateFolderEventResultToJson(
        LibraryCreateFolderEventResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
      'ID': instance.iD,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

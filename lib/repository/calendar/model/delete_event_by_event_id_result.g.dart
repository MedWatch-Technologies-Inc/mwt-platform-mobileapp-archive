// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_event_by_event_id_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteEventByEventIdResult _$DeleteEventByEventIdResultFromJson(Map json) =>
    DeleteEventByEventIdResult(
      result: json['Result'] as bool?,
      iD: json['ID'] as int?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$DeleteEventByEventIdResultToJson(
        DeleteEventByEventIdResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'ID': instance.iD,
      'Response': instance.response,
      'Message': instance.message,
    };

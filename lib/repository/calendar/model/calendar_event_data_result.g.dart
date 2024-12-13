// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event_data_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarEventDataResult _$CalendarEventDataResultFromJson(Map json) =>
    CalendarEventDataResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      iD: json['ID'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$CalendarEventDataResultToJson(
        CalendarEventDataResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'ID': instance.iD,
      'Message': instance.message,
    };

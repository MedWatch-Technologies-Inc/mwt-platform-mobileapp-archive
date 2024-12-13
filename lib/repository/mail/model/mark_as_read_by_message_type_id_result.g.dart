// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_as_read_by_message_type_id_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkAsReadByMessageTypeIdResult _$MarkAsReadByMessageTypeIdResultFromJson(
        Map json) =>
    MarkAsReadByMessageTypeIdResult(
      response: json['Response'] as int?,
      result: json['Result'] as bool?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$MarkAsReadByMessageTypeIdResultToJson(
        MarkAsReadByMessageTypeIdResult instance) =>
    <String, dynamic>{
      'Response': instance.response,
      'Result': instance.result,
      'Message': instance.message,
    };

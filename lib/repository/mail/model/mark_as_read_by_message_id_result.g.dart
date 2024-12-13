// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_as_read_by_message_id_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkAsReadByMessageIdResult _$MarkAsReadByMessageIdResultFromJson(Map json) =>
    MarkAsReadByMessageIdResult(
      result: json['Result'] as bool?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$MarkAsReadByMessageIdResultToJson(
        MarkAsReadByMessageIdResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Message': instance.message,
    };

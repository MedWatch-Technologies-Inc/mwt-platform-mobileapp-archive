// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_message_delete_from_trash_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipleMessageDeleteFromTrashResult
    _$MultipleMessageDeleteFromTrashResultFromJson(Map json) =>
        MultipleMessageDeleteFromTrashResult(
          result: json['Result'] as bool?,
          message: json['Message'] as String?,
          response: json['Response'] as int?,
        );

Map<String, dynamic> _$MultipleMessageDeleteFromTrashResultToJson(
        MultipleMessageDeleteFromTrashResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Message': instance.message,
      'Response': instance.response,
    };

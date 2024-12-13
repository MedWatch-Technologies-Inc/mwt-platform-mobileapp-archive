// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empty_messages_from_trash_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmptyMessagesFromTrashResult _$EmptyMessagesFromTrashResultFromJson(Map json) =>
    EmptyMessagesFromTrashResult(
      response: json['Response'] as int?,
      result: json['Result'] as bool?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$EmptyMessagesFromTrashResultToJson(
        EmptyMessagesFromTrashResult instance) =>
    <String, dynamic>{
      'Response': instance.response,
      'Result': instance.result,
      'Message': instance.message,
    };

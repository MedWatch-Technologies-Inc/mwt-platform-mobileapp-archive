// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_create_chat_group_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessCreateChatGroupResult _$AccessCreateChatGroupResultFromJson(Map json) =>
    AccessCreateChatGroupResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$AccessCreateChatGroupResultToJson(
        AccessCreateChatGroupResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };

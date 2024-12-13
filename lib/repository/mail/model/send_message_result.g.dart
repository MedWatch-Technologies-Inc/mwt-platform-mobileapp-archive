// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageResult _$SendMessageResultFromJson(Map json) => SendMessageResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
      iD: (json['ID'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$SendMessageResultToJson(SendMessageResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
      'ID': instance.iD,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_response_by_message_id_and_type_id_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendResponseByMessageIdAndTypeIdResult
    _$SendResponseByMessageIdAndTypeIdResultFromJson(Map json) =>
        SendResponseByMessageIdAndTypeIdResult(
          iD: (json['ID'] as List<dynamic>?)?.map((e) => e as int).toList(),
          result: json['Result'] as bool?,
          message: json['Message'] as String?,
        );

Map<String, dynamic> _$SendResponseByMessageIdAndTypeIdResultToJson(
        SendResponseByMessageIdAndTypeIdResult instance) =>
    <String, dynamic>{
      'ID': instance.iD,
      'Result': instance.result,
      'Message': instance.message,
    };

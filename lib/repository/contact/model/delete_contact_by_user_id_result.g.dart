// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_contact_by_user_id_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteContactByUserIdResult _$DeleteContactByUserIdResultFromJson(Map json) =>
    DeleteContactByUserIdResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$DeleteContactByUserIdResultToJson(
        DeleteContactByUserIdResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };

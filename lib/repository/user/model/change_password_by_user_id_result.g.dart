// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_by_user_id_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordByUserIdResult _$ChangePasswordByUserIdResultFromJson(Map json) =>
    ChangePasswordByUserIdResult(
      result: json['Result'] as bool?,
      iD: json['ID'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$ChangePasswordByUserIdResultToJson(
        ChangePasswordByUserIdResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'ID': instance.iD,
      'Message': instance.message,
    };

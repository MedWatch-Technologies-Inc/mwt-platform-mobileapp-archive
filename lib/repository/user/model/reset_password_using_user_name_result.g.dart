// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_using_user_name_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordUsingUserNameResult _$ResetPasswordUsingUserNameResultFromJson(
        Map json) =>
    ResetPasswordUsingUserNameResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$ResetPasswordUsingUserNameResultToJson(
        ResetPasswordUsingUserNameResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };

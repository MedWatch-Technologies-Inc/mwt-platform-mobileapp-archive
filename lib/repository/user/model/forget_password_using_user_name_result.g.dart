// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_password_using_user_name_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgetPasswordUsingUserNameResult _$ForgetPasswordUsingUserNameResultFromJson(
        Map json) =>
    ForgetPasswordUsingUserNameResult(
      result: json['Result'] as bool?,
      message: json['Message'] as String?,
      iD: json['ID'] as int?,
      phoneNumber: json['PhoneNumber'] as String?,
      emailAddress: json['EmailAddress'] as String?,
    );

Map<String, dynamic> _$ForgetPasswordUsingUserNameResultToJson(
        ForgetPasswordUsingUserNameResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Message': instance.message,
      'ID': instance.iD,
      'PhoneNumber': instance.phoneNumber,
      'EmailAddress': instance.emailAddress,
    };

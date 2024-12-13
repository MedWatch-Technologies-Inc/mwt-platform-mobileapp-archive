// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_using_user_name_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordUsingUserNameRequest _$ResetPasswordUsingUserNameRequestFromJson(
        Map json) =>
    ResetPasswordUsingUserNameRequest(
      userName: json['UserName'] as String?,
      verificationOTP: json['VerificationOTP'] as String?,
      confirmPassword: json['ConfirmPassword'] as String?,
    );

Map<String, dynamic> _$ResetPasswordUsingUserNameRequestToJson(
        ResetPasswordUsingUserNameRequest instance) =>
    <String, dynamic>{
      'UserName': instance.userName,
      'VerificationOTP': instance.verificationOTP,
      'ConfirmPassword': instance.confirmPassword,
    };

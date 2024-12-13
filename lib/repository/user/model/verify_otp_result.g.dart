// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpResult _$VerifyOtpResultFromJson(Map json) => VerifyOtpResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$VerifyOtpResultToJson(VerifyOtpResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };

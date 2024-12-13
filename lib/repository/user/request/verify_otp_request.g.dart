// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpRequest _$VerifyOtpRequestFromJson(Map json) => VerifyOtpRequest(
      userName: json['UserName'] as String?,
      verificationOTP: json['VerificationOTP'] as String?,
    );

Map<String, dynamic> _$VerifyOtpRequestToJson(VerifyOtpRequest instance) =>
    <String, dynamic>{
      'UserName': instance.userName,
      'VerificationOTP': instance.verificationOTP,
    };

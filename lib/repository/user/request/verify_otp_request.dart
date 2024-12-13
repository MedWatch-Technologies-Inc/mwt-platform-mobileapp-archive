import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request.g.dart';

@JsonSerializable()
class VerifyOtpRequest extends Object {
  @JsonKey(name: 'UserName')
  String? userName;

  @JsonKey(name: 'VerificationOTP')
  String? verificationOTP;

  VerifyOtpRequest({
    this.userName,
    this.verificationOTP,
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$VerifyOtpRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}

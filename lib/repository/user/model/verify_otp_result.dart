import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_result.g.dart';

@JsonSerializable()
class VerifyOtpResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  VerifyOtpResult({this.result, this.response, this.message});

  factory VerifyOtpResult.fromJson(Map<String, dynamic> srcJson) =>
      _$VerifyOtpResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VerifyOtpResultToJson(this);
}

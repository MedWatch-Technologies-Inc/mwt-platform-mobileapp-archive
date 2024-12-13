import 'package:json_annotation/json_annotation.dart';

part 'reset_password_using_user_name_request.g.dart';

@JsonSerializable()
class ResetPasswordUsingUserNameRequest extends Object {
  @JsonKey(name: 'UserName')
  String? userName;

  @JsonKey(name: 'VerificationOTP')
  String? verificationOTP;

  @JsonKey(name: 'ConfirmPassword')
  String? confirmPassword;

  ResetPasswordUsingUserNameRequest({
    this.userName,
    this.verificationOTP,
    this.confirmPassword,
  });

  factory ResetPasswordUsingUserNameRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$ResetPasswordUsingUserNameRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$ResetPasswordUsingUserNameRequestToJson(this);
}

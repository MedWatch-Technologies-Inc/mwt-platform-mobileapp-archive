import 'package:json_annotation/json_annotation.dart';

part 'forget_password_using_user_name_result.g.dart';

@JsonSerializable()
class ForgetPasswordUsingUserNameResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'PhoneNumber')
  String? phoneNumber;

  @JsonKey(name: 'EmailAddress')
  String? emailAddress;

  ForgetPasswordUsingUserNameResult({
    this.result,
    this.message,
    this.iD,
    this.phoneNumber,
    this.emailAddress,
  });

  factory ForgetPasswordUsingUserNameResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$ForgetPasswordUsingUserNameResultFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$ForgetPasswordUsingUserNameResultToJson(this);
}

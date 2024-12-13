import 'package:json_annotation/json_annotation.dart';

part 'forget_password_using_user_name_request.g.dart';

@JsonSerializable()
class ForgetPasswordUsingUserNameRequest extends Object {
  @JsonKey(name: 'UserName')
  String? userName;

  ForgetPasswordUsingUserNameRequest({
    this.userName,
  });

  factory ForgetPasswordUsingUserNameRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$ForgetPasswordUsingUserNameRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$ForgetPasswordUsingUserNameRequestToJson(this);
}

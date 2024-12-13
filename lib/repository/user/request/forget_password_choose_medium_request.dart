import 'package:json_annotation/json_annotation.dart';

part 'forget_password_choose_medium_request.g.dart';

@JsonSerializable()
class ForgetPasswordChooseMediumRequest extends Object {
  @JsonKey(name: 'UserName')
  String? userName;

  @JsonKey(name: 'isPhone')
  bool? isPhone;

  ForgetPasswordChooseMediumRequest({
    this.userName,
    this.isPhone,
  });

  factory ForgetPasswordChooseMediumRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$ForgetPasswordChooseMediumRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$ForgetPasswordChooseMediumRequestToJson(this);
}

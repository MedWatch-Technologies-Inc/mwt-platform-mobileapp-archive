import 'package:json_annotation/json_annotation.dart';

part 'forget_password_choose_medium_result.g.dart';

@JsonSerializable()
class ForgetPasswordChooseMediumResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'Message')
  String? message;

  ForgetPasswordChooseMediumResult({
    this.result,
    this.iD,
    this.message,
  });

  factory ForgetPasswordChooseMediumResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$ForgetPasswordChooseMediumResultFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$ForgetPasswordChooseMediumResultToJson(this);
}

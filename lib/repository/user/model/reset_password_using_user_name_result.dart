import 'package:json_annotation/json_annotation.dart';

part 'reset_password_using_user_name_result.g.dart';

@JsonSerializable()
class ResetPasswordUsingUserNameResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  ResetPasswordUsingUserNameResult({this.result, this.response, this.message});

  factory ResetPasswordUsingUserNameResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$ResetPasswordUsingUserNameResultFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$ResetPasswordUsingUserNameResultToJson(this);
}

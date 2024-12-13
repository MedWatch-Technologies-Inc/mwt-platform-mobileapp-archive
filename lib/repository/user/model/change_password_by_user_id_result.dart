import 'package:json_annotation/json_annotation.dart';

part 'change_password_by_user_id_result.g.dart';

@JsonSerializable()
class ChangePasswordByUserIdResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'Message')
  String? message;

  ChangePasswordByUserIdResult({
    this.result,
    this.iD,
    this.message,
  });

  factory ChangePasswordByUserIdResult.fromJson(Map<String, dynamic> srcJson) =>
      _$ChangePasswordByUserIdResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ChangePasswordByUserIdResultToJson(this);
}

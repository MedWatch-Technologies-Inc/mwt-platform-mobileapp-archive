import 'package:json_annotation/json_annotation.dart';

part 'forget_user_id_result.g.dart';

@JsonSerializable()
class ForgetUserIdResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Message')
  String? message;

  ForgetUserIdResult({
    this.result,
    this.message,
  });

  factory ForgetUserIdResult.fromJson(Map<String, dynamic> srcJson) =>
      _$ForgetUserIdResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ForgetUserIdResultToJson(this);
}

import 'package:health_gauge/repository/auth/model/user_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_result.g.dart';

@JsonSerializable()
class LoginResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'Salt')
  String? salt;

  @JsonKey(name: 'Data')
  UserResult? data;

  @JsonKey(name: 'Errors')
  List<dynamic>? errors;

  LoginResult({
    this.result,
    this.response,
    this.iD,
    this.message,
    this.data,
    this.salt,
    this.errors,
  });

  factory LoginResult.fromJson(Map<String, dynamic> srcJson) =>
      _$LoginResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}

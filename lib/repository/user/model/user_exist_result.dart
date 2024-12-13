import 'package:json_annotation/json_annotation.dart'; 
  
part 'user_exist_result.g.dart';


@JsonSerializable()
  class UserExistResult extends Object {

  @JsonKey(name: 'Result')
  bool result;

  @JsonKey(name: 'Message')
  String message;

  UserExistResult(this.result,this.message,);

  factory UserExistResult.fromJson(Map<String, dynamic> srcJson) => _$UserExistResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserExistResultToJson(this);

}

  

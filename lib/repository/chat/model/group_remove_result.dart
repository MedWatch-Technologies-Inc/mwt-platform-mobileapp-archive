import 'package:json_annotation/json_annotation.dart';

part 'group_remove_result.g.dart';

@JsonSerializable()
class GroupRemoveResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  GroupRemoveResult({
    this.result,
    this.response,
    this.message,
  });

  factory GroupRemoveResult.fromJson(Map<String, dynamic> srcJson) =>
      _$GroupRemoveResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GroupRemoveResultToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'access_send_group_result.g.dart';

@JsonSerializable()
class AccessSendGroupResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'senderUserName')
  String? senderUserName;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'groupName')
  String? groupName;

  AccessSendGroupResult({
    this.result,
    this.senderUserName,
    this.message,
    this.groupName,
  });

  factory AccessSendGroupResult.fromJson(Map<String, dynamic> srcJson) =>
      _$AccessSendGroupResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccessSendGroupResultToJson(this);
}

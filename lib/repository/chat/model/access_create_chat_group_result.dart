import 'package:json_annotation/json_annotation.dart';

part 'access_create_chat_group_result.g.dart';

@JsonSerializable()
class AccessCreateChatGroupResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  AccessCreateChatGroupResult({
    this.result,
    this.response,
    this.message,
  });

  factory AccessCreateChatGroupResult.fromJson(Map<String, dynamic> srcJson) =>
      _$AccessCreateChatGroupResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccessCreateChatGroupResultToJson(this);
}

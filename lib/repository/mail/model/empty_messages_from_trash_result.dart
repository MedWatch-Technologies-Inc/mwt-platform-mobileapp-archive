import 'package:json_annotation/json_annotation.dart';

part 'empty_messages_from_trash_result.g.dart';

@JsonSerializable()
class EmptyMessagesFromTrashResult extends Object {
  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Message')
  String? message;

  EmptyMessagesFromTrashResult({
    this.response,
    this.result,
    this.message,
  });

  factory EmptyMessagesFromTrashResult.fromJson(Map<String, dynamic> srcJson) =>
      _$EmptyMessagesFromTrashResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EmptyMessagesFromTrashResultToJson(this);
}

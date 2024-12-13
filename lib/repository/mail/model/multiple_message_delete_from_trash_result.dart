import 'package:json_annotation/json_annotation.dart';

part 'multiple_message_delete_from_trash_result.g.dart';

@JsonSerializable()
class MultipleMessageDeleteFromTrashResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'Response')
  int? response;

  MultipleMessageDeleteFromTrashResult({
    this.result,
    this.message,
    this.response,
  });

  factory MultipleMessageDeleteFromTrashResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$MultipleMessageDeleteFromTrashResultFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$MultipleMessageDeleteFromTrashResultToJson(this);
}

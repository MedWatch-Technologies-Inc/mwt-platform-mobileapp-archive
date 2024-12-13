import 'package:json_annotation/json_annotation.dart';

part 'mark_as_read_by_message_id_result.g.dart';

@JsonSerializable()
class MarkAsReadByMessageIdResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Message')
  String? message;

  MarkAsReadByMessageIdResult({
    this.result,
    this.message,
  });

  factory MarkAsReadByMessageIdResult.fromJson(Map<String, dynamic> srcJson) =>
      _$MarkAsReadByMessageIdResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MarkAsReadByMessageIdResultToJson(this);
}

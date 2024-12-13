import 'package:json_annotation/json_annotation.dart';

part 'mark_as_read_by_message_type_id_result.g.dart';

@JsonSerializable()
class MarkAsReadByMessageTypeIdResult extends Object {
  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Message')
  String? message;

  MarkAsReadByMessageTypeIdResult({
    this.response,
    this.result,
    this.message,
  });

  factory MarkAsReadByMessageTypeIdResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$MarkAsReadByMessageTypeIdResultFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$MarkAsReadByMessageTypeIdResultToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'send_response_by_message_id_and_type_id_result.g.dart';

@JsonSerializable()
class SendResponseByMessageIdAndTypeIdResult extends Object {
  @JsonKey(name: 'ID')
  List<int>? iD;

  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Message')
  String? message;

  SendResponseByMessageIdAndTypeIdResult({
    this.iD,
    this.result,
    this.message,
  });

  factory SendResponseByMessageIdAndTypeIdResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$SendResponseByMessageIdAndTypeIdResultFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$SendResponseByMessageIdAndTypeIdResultToJson(this);
}

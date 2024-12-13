import 'package:json_annotation/json_annotation.dart';

part 'send_message_result.g.dart';

@JsonSerializable()
class SendMessageResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'ID')
  List<int>? iD;

  SendMessageResult({
    this.result,
    this.response,
    this.message,
    this.iD,
  });

  factory SendMessageResult.fromJson(Map<String, dynamic> srcJson) =>
      _$SendMessageResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendMessageResultToJson(this);
}

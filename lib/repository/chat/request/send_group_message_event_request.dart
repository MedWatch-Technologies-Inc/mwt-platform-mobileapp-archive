import 'package:json_annotation/json_annotation.dart';

part 'send_group_message_event_request.g.dart';

@JsonSerializable()
class SendGroupMessageEventRequest extends Object {
  @JsonKey(name: 'groupName')
  String? groupName;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'senderUserName')
  String? senderUserName;

  SendGroupMessageEventRequest({
    this.groupName,
    this.message,
    this.senderUserName,
  });

  factory SendGroupMessageEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$SendGroupMessageEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendGroupMessageEventRequestToJson(this);
}

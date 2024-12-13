import 'package:json_annotation/json_annotation.dart';

part 'message_restore_event_request.g.dart';

@JsonSerializable()
class MessageRestoreEventRequest extends Object {
  @JsonKey(name: 'MessageID')
  int? messageID;

  @JsonKey(name: 'UserId')
  int? userId;

  MessageRestoreEventRequest({
    this.messageID,
    this.userId,
  });

  factory MessageRestoreEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$MessageRestoreEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MessageRestoreEventRequestToJson(this);
}

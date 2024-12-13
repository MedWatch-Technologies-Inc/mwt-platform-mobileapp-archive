import 'package:json_annotation/json_annotation.dart';

part 'chat_group_history_event_request.g.dart';

@JsonSerializable()
class ChatGroupHistoryEventRequest extends Object {
  @JsonKey(name: 'groupName')
  String? groupName;

  ChatGroupHistoryEventRequest({
    this.groupName,
  });

  factory ChatGroupHistoryEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$ChatGroupHistoryEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ChatGroupHistoryEventRequestToJson(this);
}

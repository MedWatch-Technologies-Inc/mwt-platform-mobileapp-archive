import 'package:json_annotation/json_annotation.dart';

part 'get_message_detail_event_request.g.dart';

@JsonSerializable()
class GetMessageDetailEventRequest extends Object {
  @JsonKey(name: 'MessageID')
  int? messageID;

  @JsonKey(name: 'LogedInEmailID')
  String? loggedInEmailID;

  GetMessageDetailEventRequest({
    this.messageID,
    this.loggedInEmailID,
  });

  factory GetMessageDetailEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$GetMessageDetailEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetMessageDetailEventRequestToJson(this);
}

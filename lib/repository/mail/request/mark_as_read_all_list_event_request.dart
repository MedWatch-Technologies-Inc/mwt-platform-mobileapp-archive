import 'package:json_annotation/json_annotation.dart';

part 'mark_as_read_all_list_event_request.g.dart';

@JsonSerializable()
class MarkAsReadAllListEventRequest extends Object {
  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'MessageTypeid')
  int? messageTypeId;

  MarkAsReadAllListEventRequest({
    this.userID,
    this.messageTypeId,
  });

  factory MarkAsReadAllListEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$MarkAsReadAllListEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MarkAsReadAllListEventRequestToJson(this);
}

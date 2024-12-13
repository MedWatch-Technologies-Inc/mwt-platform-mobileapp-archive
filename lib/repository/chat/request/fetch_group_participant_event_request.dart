import 'package:json_annotation/json_annotation.dart';

part 'fetch_group_participant_event_request.g.dart';

@JsonSerializable()
class FetchGroupParticipantEventRequest extends Object {
  @JsonKey(name: 'groupName')
  String? groupName;

  FetchGroupParticipantEventRequest({
    this.groupName,
  });

  factory FetchGroupParticipantEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$FetchGroupParticipantEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$FetchGroupParticipantEventRequestToJson(this);
}

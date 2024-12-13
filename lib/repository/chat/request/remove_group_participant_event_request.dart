import 'package:json_annotation/json_annotation.dart';

part 'remove_group_participant_event_request.g.dart';

@JsonSerializable()
class RemoveGroupParticipantEventRequest extends Object {
  @JsonKey(name: 'groupName')
  String? groupName;

  @JsonKey(name: 'MembersIDs')
  String? membersIDs;

  RemoveGroupParticipantEventRequest({
    this.groupName,
    this.membersIDs,
  });

  factory RemoveGroupParticipantEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$RemoveGroupParticipantEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$RemoveGroupParticipantEventRequestToJson(this);
}

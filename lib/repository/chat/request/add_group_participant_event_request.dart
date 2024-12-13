import 'package:json_annotation/json_annotation.dart';

part 'add_group_participant_event_request.g.dart';

@JsonSerializable()
class AddGroupParticipantEventRequest extends Object {
  @JsonKey(name: 'groupName')
  String? groupName;

  @JsonKey(name: 'MembersIDs')
  String? membersIDs;

  AddGroupParticipantEventRequest({
    this.groupName,
    this.membersIDs,
  });

  factory AddGroupParticipantEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$AddGroupParticipantEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$AddGroupParticipantEventRequestToJson(this);
}

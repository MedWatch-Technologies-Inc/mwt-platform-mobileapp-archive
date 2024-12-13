import 'package:json_annotation/json_annotation.dart';

part 'send_invitation_event_request.g.dart';

@JsonSerializable()
class SendInvitationEventRequest extends Object {
  @JsonKey(name: 'LoggedinUserID')
  String? loggedInUserID;

  @JsonKey(name: 'InviteeUserID')
  String? inviteeUserID;

  SendInvitationEventRequest({
    this.loggedInUserID,
    this.inviteeUserID,
  });

  factory SendInvitationEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$SendInvitationEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendInvitationEventRequestToJson(this);
}

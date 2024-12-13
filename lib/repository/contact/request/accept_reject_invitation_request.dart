import 'package:json_annotation/json_annotation.dart';

part 'accept_reject_invitation_request.g.dart';

@JsonSerializable()
class AcceptRejectInvitationRequest extends Object {
  @JsonKey(name: 'ContactID')
  String? contactID;

  @JsonKey(name: 'IsAccepted')
  String? isAccepted;

  AcceptRejectInvitationRequest({
    this.contactID,
    this.isAccepted,
  });

  factory AcceptRejectInvitationRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$AcceptRejectInvitationRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AcceptRejectInvitationRequestToJson(this);
}

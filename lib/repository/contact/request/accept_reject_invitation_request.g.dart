// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_reject_invitation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptRejectInvitationRequest _$AcceptRejectInvitationRequestFromJson(
        Map json) =>
    AcceptRejectInvitationRequest(
      contactID: json['ContactID'] as String?,
      isAccepted: json['IsAccepted'] as String?,
    );

Map<String, dynamic> _$AcceptRejectInvitationRequestToJson(
        AcceptRejectInvitationRequest instance) =>
    <String, dynamic>{
      'ContactID': instance.contactID,
      'IsAccepted': instance.isAccepted,
    };

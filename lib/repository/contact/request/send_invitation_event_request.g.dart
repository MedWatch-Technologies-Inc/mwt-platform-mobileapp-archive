// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_invitation_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendInvitationEventRequest _$SendInvitationEventRequestFromJson(Map json) =>
    SendInvitationEventRequest(
      loggedInUserID: json['LoggedinUserID'] as String?,
      inviteeUserID: json['InviteeUserID'] as String?,
    );

Map<String, dynamic> _$SendInvitationEventRequestToJson(
        SendInvitationEventRequest instance) =>
    <String, dynamic>{
      'LoggedinUserID': instance.loggedInUserID,
      'InviteeUserID': instance.inviteeUserID,
    };

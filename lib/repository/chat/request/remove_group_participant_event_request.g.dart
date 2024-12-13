// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_group_participant_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveGroupParticipantEventRequest _$RemoveGroupParticipantEventRequestFromJson(
        Map json) =>
    RemoveGroupParticipantEventRequest(
      groupName: json['groupName'] as String?,
      membersIDs: json['MembersIDs'] as String?,
    );

Map<String, dynamic> _$RemoveGroupParticipantEventRequestToJson(
        RemoveGroupParticipantEventRequest instance) =>
    <String, dynamic>{
      'groupName': instance.groupName,
      'MembersIDs': instance.membersIDs,
    };

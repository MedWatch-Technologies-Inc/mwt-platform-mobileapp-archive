// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_group_participant_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddGroupParticipantEventRequest _$AddGroupParticipantEventRequestFromJson(
        Map json) =>
    AddGroupParticipantEventRequest(
      groupName: json['groupName'] as String?,
      membersIDs: json['MembersIDs'] as String?,
    );

Map<String, dynamic> _$AddGroupParticipantEventRequestToJson(
        AddGroupParticipantEventRequest instance) =>
    <String, dynamic>{
      'groupName': instance.groupName,
      'MembersIDs': instance.membersIDs,
    };

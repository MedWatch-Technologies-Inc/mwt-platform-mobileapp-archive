// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_group_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGroupEventRequest _$CreateGroupEventRequestFromJson(Map json) =>
    CreateGroupEventRequest(
      groupName: json['groupName'] as String?,
      memberIds: json['memberIds'] as String?,
    );

Map<String, dynamic> _$CreateGroupEventRequestToJson(
        CreateGroupEventRequest instance) =>
    <String, dynamic>{
      'groupName': instance.groupName,
      'memberIds': instance.memberIds,
    };

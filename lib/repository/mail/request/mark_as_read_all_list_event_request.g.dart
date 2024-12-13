// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_as_read_all_list_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkAsReadAllListEventRequest _$MarkAsReadAllListEventRequestFromJson(
        Map json) =>
    MarkAsReadAllListEventRequest(
      userID: json['UserID'] as int?,
      messageTypeId: json['MessageTypeid'] as int?,
    );

Map<String, dynamic> _$MarkAsReadAllListEventRequestToJson(
        MarkAsReadAllListEventRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'MessageTypeid': instance.messageTypeId,
    };

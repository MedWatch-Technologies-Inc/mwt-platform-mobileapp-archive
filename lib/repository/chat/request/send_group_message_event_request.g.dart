// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_group_message_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendGroupMessageEventRequest _$SendGroupMessageEventRequestFromJson(Map json) =>
    SendGroupMessageEventRequest(
      groupName: json['groupName'] as String?,
      message: json['message'] as String?,
      senderUserName: json['senderUserName'] as String?,
    );

Map<String, dynamic> _$SendGroupMessageEventRequestToJson(
        SendGroupMessageEventRequest instance) =>
    <String, dynamic>{
      'groupName': instance.groupName,
      'message': instance.message,
      'senderUserName': instance.senderUserName,
    };

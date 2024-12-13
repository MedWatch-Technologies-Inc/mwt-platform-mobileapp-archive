// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_restore_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageRestoreEventRequest _$MessageRestoreEventRequestFromJson(Map json) =>
    MessageRestoreEventRequest(
      messageID: json['MessageID'] as int?,
      userId: json['UserId'] as int?,
    );

Map<String, dynamic> _$MessageRestoreEventRequestToJson(
        MessageRestoreEventRequest instance) =>
    <String, dynamic>{
      'MessageID': instance.messageID,
      'UserId': instance.userId,
    };

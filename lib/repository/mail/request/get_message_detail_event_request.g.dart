// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_message_detail_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMessageDetailEventRequest _$GetMessageDetailEventRequestFromJson(Map json) =>
    GetMessageDetailEventRequest(
      messageID: json['MessageID'] as int?,
      loggedInEmailID: json['LogedInEmailID'] as String?,
    );

Map<String, dynamic> _$GetMessageDetailEventRequestToJson(
        GetMessageDetailEventRequest instance) =>
    <String, dynamic>{
      'MessageID': instance.messageID,
      'LogedInEmailID': instance.loggedInEmailID,
    };

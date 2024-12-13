// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_response_message_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendResponseMessageEventRequest _$SendResponseMessageEventRequestFromJson(
        Map json) =>
    SendResponseMessageEventRequest(
      messageID: json['MessageID'] as int?,
      msgResponseTypeID: json['MsgResponseTypeID'] as int?,
      messageFrom: json['MessageFrom'] as String?,
      messageTo: json['MessageTo'] as String?,
      messageCc: json['MessageCc'] as String?,
      messageSubject: json['MessageSubject'] as String?,
      messageBody: json['MessageBody'] as String?,
      fileExtension: json['FileExtension'] as String?,
      userFile: json['UserFile'] as String?,
      parentGUIID: json['ParentGUIID'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$SendResponseMessageEventRequestToJson(
        SendResponseMessageEventRequest instance) =>
    <String, dynamic>{
      'MessageID': instance.messageID,
      'MsgResponseTypeID': instance.msgResponseTypeID,
      'MessageFrom': instance.messageFrom,
      'MessageTo': instance.messageTo,
      'MessageCc': instance.messageCc,
      'MessageSubject': instance.messageSubject,
      'MessageBody': instance.messageBody,
      'FileExtension': instance.fileExtension,
      'UserFile': instance.userFile,
      'ParentGUIID': instance.parentGUIID,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

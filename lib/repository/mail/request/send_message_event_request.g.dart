// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageEventRequest _$SendMessageEventRequestFromJson(Map json) =>
    SendMessageEventRequest(
      messageFrom: json['MessageFrom'] as String?,
      messageTo: json['MessageTo'] as String?,
      messageCc: json['MessageCc'] as String?,
      messageSubject: json['MessageSubject'] as String?,
      messageBody: json['MessageBody'] as String?,
      fileExtension: json['FileExtension'] as String?,
      userFile: json['UserFile'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$SendMessageEventRequestToJson(
        SendMessageEventRequest instance) =>
    <String, dynamic>{
      'MessageFrom': instance.messageFrom,
      'MessageTo': instance.messageTo,
      'MessageCc': instance.messageCc,
      'MessageSubject': instance.messageSubject,
      'MessageBody': instance.messageBody,
      'FileExtension': instance.fileExtension,
      'UserFile': instance.userFile,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

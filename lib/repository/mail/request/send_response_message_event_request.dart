import 'package:json_annotation/json_annotation.dart';

part 'send_response_message_event_request.g.dart';

@JsonSerializable()
class SendResponseMessageEventRequest extends Object {
  @JsonKey(name: 'MessageID')
  int? messageID;

  @JsonKey(name: 'MsgResponseTypeID')
  int? msgResponseTypeID;

  @JsonKey(name: 'MessageFrom')
  String? messageFrom;

  @JsonKey(name: 'MessageTo')
  String? messageTo;

  @JsonKey(name: 'MessageCc')
  String? messageCc;

  @JsonKey(name: 'MessageSubject')
  String? messageSubject;

  @JsonKey(name: 'MessageBody')
  String? messageBody;

  @JsonKey(name: 'FileExtension')
  String? fileExtension;

  @JsonKey(name: 'UserFile')
  String? userFile;

  @JsonKey(name: 'ParentGUIID')
  String? parentGUIID;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  SendResponseMessageEventRequest({
    this.messageID,
    this.msgResponseTypeID,
    this.messageFrom,
    this.messageTo,
    this.messageCc,
    this.messageSubject,
    this.messageBody,
    this.fileExtension,
    this.userFile,
    this.parentGUIID,
    this.createdDateTimeStamp,
  });

  factory SendResponseMessageEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$SendResponseMessageEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$SendResponseMessageEventRequestToJson(this);
}

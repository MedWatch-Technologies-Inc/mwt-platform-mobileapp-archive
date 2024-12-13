import 'package:json_annotation/json_annotation.dart';

part 'send_message_event_request.g.dart';

@JsonSerializable()
class SendMessageEventRequest extends Object {
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

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  SendMessageEventRequest({
    this.messageFrom,
    this.messageTo,
    this.messageCc,
    this.messageSubject,
    this.messageBody,
    this.fileExtension,
    this.userFile,
    this.createdDateTimeStamp,
  });

  factory SendMessageEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$SendMessageEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendMessageEventRequestToJson(this);
}

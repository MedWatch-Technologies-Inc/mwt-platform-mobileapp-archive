import 'package:json_annotation/json_annotation.dart';

part 'get_message_detail_by_message_id_result.g.dart';

@JsonSerializable()
class GetMessageDetailByMessageIdResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  GetMessageDetailByMessageIdData? data;

  GetMessageDetailByMessageIdResult({
    this.result,
    this.iD,
    this.response,
    this.data,
  });

  factory GetMessageDetailByMessageIdResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetMessageDetailByMessageIdResultFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$GetMessageDetailByMessageIdResultToJson(this);
}

@JsonSerializable()
class GetMessageDetailByMessageIdData extends Object {
  @JsonKey(name: 'MessageID')
  int? messageID;

  @JsonKey(name: 'SenderUserID')
  int? senderUserID;

  @JsonKey(name: 'ReceiverUserID')
  int? receiverUserID;

  @JsonKey(name: 'FkMessageTypeID')
  int? fkMessageTypeID;

  @JsonKey(name: 'MessageTypeName')
  String? messageTypeName;

  @JsonKey(name: 'MessageFrom')
  String? messageFrom;

  @JsonKey(name: 'MessageTo')
  String? messageTo;

  @JsonKey(name: 'MessageSubject')
  String? messageSubject;

  @JsonKey(name: 'MessageBody')
  String? messageBody;

  @JsonKey(name: 'CreatedDateTime')
  String? createdDateTime;

  @JsonKey(name: 'IsViewed')
  bool? isViewed;

  @JsonKey(name: 'IsDeleted')
  bool? isDeleted;

  @JsonKey(name: 'TotalRecords')
  int? totalRecords;

  @JsonKey(name: 'PageFrom')
  int? pageFrom;

  @JsonKey(name: 'PageTo')
  int? pageTo;

  @JsonKey(name: 'LoginUserID')
  int? loginUserID;

  @JsonKey(name: 'SenderUserName')
  String? senderUserName;

  @JsonKey(name: 'ReceiverUserName')
  String? receiverUserName;

  @JsonKey(name: 'AttachmentFiles')
  List<dynamic>? attachmentFiles;

  @JsonKey(name: 'MessageCreatedDateTime')
  String? messageCreatedDateTime;

  @JsonKey(name: 'MessageTree')
  List<GetMessageDetailByMessageIdData>? messageTree;

  @JsonKey(name: 'ReplyMessageID')
  int? replyMessageID;

  @JsonKey(name: 'FKMessageID')
  int? fKMessageID;

  @JsonKey(name: 'UserNameCc')
  String? userNameCc;

  @JsonKey(name: 'MsgResponseTypeID')
  int? msgResponseTypeID;

  @JsonKey(name: 'ReplyMessageCount')
  int? replyMessageCount;

  @JsonKey(name: 'ParentGUIID')
  String? parentGUIID;

  @JsonKey(name: 'LastInboxMessageID')
  int? lastInboxMessageID;

  @JsonKey(name: 'UnreadMessageCount')
  int? unreadMessageCount;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'pageSize')
  int? pageSize;

  @JsonKey(name: 'pageNumber')
  int? pageNumber;

  @JsonKey(name: 'MessageTypeid')
  int? messageTypeid;

  @JsonKey(name: 'TotalInboxMessageCount')
  int? totalInboxMessageCount;

  @JsonKey(name: 'TotalSendboxMessageCount')
  int? totalSendboxMessageCount;

  @JsonKey(name: 'TotalDraftMessageCount')
  int? totalDraftMessageCount;

  @JsonKey(name: 'TotalTrashMessageCount')
  int? totalTrashMessageCount;

  GetMessageDetailByMessageIdData({
    this.messageID,
    this.senderUserID,
    this.receiverUserID,
    this.fkMessageTypeID,
    this.messageTypeName,
    this.messageFrom,
    this.messageTo,
    this.messageSubject,
    this.messageBody,
    this.createdDateTime,
    this.isViewed,
    this.isDeleted,
    this.totalRecords,
    this.pageFrom,
    this.pageTo,
    this.loginUserID,
    this.senderUserName,
    this.receiverUserName,
    this.attachmentFiles,
    this.messageCreatedDateTime,
    this.messageTree,
    this.replyMessageID,
    this.fKMessageID,
    this.userNameCc,
    this.msgResponseTypeID,
    this.replyMessageCount,
    this.parentGUIID,
    this.lastInboxMessageID,
    this.unreadMessageCount,
    this.userID,
    this.pageSize,
    this.pageNumber,
    this.messageTypeid,
    this.totalInboxMessageCount,
    this.totalSendboxMessageCount,
    this.totalDraftMessageCount,
    this.totalTrashMessageCount,
  });

  factory GetMessageDetailByMessageIdData.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetMessageDetailByMessageIdDataFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$GetMessageDetailByMessageIdDataToJson(this);
}

// @JsonSerializable()
// class MessageTree extends Object {
//   @JsonKey(name: 'MessageID')
//   int? messageID;
//
//   @JsonKey(name: 'SenderUserID')
//   int? senderUserID;
//
//   @JsonKey(name: 'ReceiverUserID')
//   int? receiverUserID;
//
//   @JsonKey(name: 'FkMessageTypeID')
//   int? fkMessageTypeID;
//
//   @JsonKey(name: 'MessageFrom')
//   String? messageFrom;
//
//   @JsonKey(name: 'MessageTo')
//   String? messageTo;
//
//   @JsonKey(name: 'MessageSubject')
//   String? messageSubject;
//
//   @JsonKey(name: 'MessageBody')
//   String? messageBody;
//
//   @JsonKey(name: 'CreatedDateTime')
//   String? createdDateTime;
//
//   @JsonKey(name: 'IsViewed')
//   bool? isViewed;
//
//   @JsonKey(name: 'IsDeleted')
//   bool? isDeleted;
//
//   @JsonKey(name: 'TotalRecords')
//   int? totalRecords;
//
//   @JsonKey(name: 'PageFrom')
//   int? pageFrom;
//
//   @JsonKey(name: 'PageTo')
//   int? pageTo;
//
//   @JsonKey(name: 'LoginUserID')
//   int? loginUserID;
//
//   @JsonKey(name: 'SenderUserName')
//   String? senderUserName;
//
//   @JsonKey(name: 'ReceiverUserName')
//   String? receiverUserName;
//
//   @JsonKey(name: 'MessageCreatedDateTime')
//   String? messageCreatedDateTime;
//
//   @JsonKey(name: 'UserNameCc')
//   String? userNameCc;
//
//   @JsonKey(name: 'MsgResponseTypeID')
//   int? msgResponseTypeID;
//
//   @JsonKey(name: 'ReplyMessageCount')
//   int? replyMessageCount;
//
//   @JsonKey(name: 'ParentGUIID')
//   String? parentGUIID;
//
//   @JsonKey(name: 'LastInboxMessageID')
//   int? lastInboxMessageID;
//
//   @JsonKey(name: 'UnreadMessageCount')
//   int? unreadMessageCount;
//
//   @JsonKey(name: 'UserID')
//   int? userID;
//
//   @JsonKey(name: 'pageSize')
//   int? pageSize;
//
//   @JsonKey(name: 'pageNumber')
//   int? pageNumber;
//
//   @JsonKey(name: 'MessageTypeid')
//   int? messageTypeid;
//
//   @JsonKey(name: 'TotalInboxMessageCount')
//   int? totalInboxMessageCount;
//
//   @JsonKey(name: 'TotalSendboxMessageCount')
//   int? totalSendboxMessageCount;
//
//   @JsonKey(name: 'TotalDraftMessageCount')
//   int? totalDraftMessageCount;
//
//   @JsonKey(name: 'TotalTrashMessageCount')
//   int? totalTrashMessageCount;
//
//   MessageTree({
//     this.messageID,
//     this.senderUserID,
//     this.receiverUserID,
//     this.fkMessageTypeID,
//     this.messageFrom,
//     this.messageTo,
//     this.messageSubject,
//     this.messageBody,
//     this.createdDateTime,
//     this.isViewed,
//     this.isDeleted,
//     this.totalRecords,
//     this.pageFrom,
//     this.pageTo,
//     this.loginUserID,
//     this.senderUserName,
//     this.receiverUserName,
//     this.messageCreatedDateTime,
//     this.userNameCc,
//     this.msgResponseTypeID,
//     this.replyMessageCount,
//     this.parentGUIID,
//     this.lastInboxMessageID,
//     this.unreadMessageCount,
//     this.userID,
//     this.pageSize,
//     this.pageNumber,
//     this.messageTypeid,
//     this.totalInboxMessageCount,
//     this.totalSendboxMessageCount,
//     this.totalDraftMessageCount,
//     this.totalTrashMessageCount,}
//   );
//
//   factory MessageTree.fromJson(Map<String, dynamic> srcJson) =>
//       _$MessageTreeFromJson(srcJson);
//
//   Map<String, dynamic> toJson() => _$MessageTreeToJson(this);
// }

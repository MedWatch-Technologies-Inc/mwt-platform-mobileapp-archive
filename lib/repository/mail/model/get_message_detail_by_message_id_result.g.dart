// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_message_detail_by_message_id_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMessageDetailByMessageIdResult _$GetMessageDetailByMessageIdResultFromJson(
        Map json) =>
    GetMessageDetailByMessageIdResult(
      result: json['Result'] as bool?,
      iD: json['ID'] as int?,
      response: json['Response'] as int?,
      data: json['Data'] == null
          ? null
          : GetMessageDetailByMessageIdData.fromJson(
              Map<String, dynamic>.from(json['Data'] as Map)),
    );

Map<String, dynamic> _$GetMessageDetailByMessageIdResultToJson(
        GetMessageDetailByMessageIdResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'ID': instance.iD,
      'Response': instance.response,
      'Data': instance.data?.toJson(),
    };

GetMessageDetailByMessageIdData _$GetMessageDetailByMessageIdDataFromJson(
        Map json) =>
    GetMessageDetailByMessageIdData(
      messageID: json['MessageID'] as int?,
      senderUserID: json['SenderUserID'] as int?,
      receiverUserID: json['ReceiverUserID'] as int?,
      fkMessageTypeID: json['FkMessageTypeID'] as int?,
      messageTypeName: json['MessageTypeName'] as String?,
      messageFrom: json['MessageFrom'] as String?,
      messageTo: json['MessageTo'] as String?,
      messageSubject: json['MessageSubject'] as String?,
      messageBody: json['MessageBody'] as String?,
      createdDateTime: json['CreatedDateTime'] as String?,
      isViewed: json['IsViewed'] as bool?,
      isDeleted: json['IsDeleted'] as bool?,
      totalRecords: json['TotalRecords'] as int?,
      pageFrom: json['PageFrom'] as int?,
      pageTo: json['PageTo'] as int?,
      loginUserID: json['LoginUserID'] as int?,
      senderUserName: json['SenderUserName'] as String?,
      receiverUserName: json['ReceiverUserName'] as String?,
      attachmentFiles: json['AttachmentFiles'] as List<dynamic>?,
      messageCreatedDateTime: json['MessageCreatedDateTime'] as String?,
      messageTree: (json['MessageTree'] as List<dynamic>?)
          ?.map((e) => GetMessageDetailByMessageIdData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      replyMessageID: json['ReplyMessageID'] as int?,
      fKMessageID: json['FKMessageID'] as int?,
      userNameCc: json['UserNameCc'] as String?,
      msgResponseTypeID: json['MsgResponseTypeID'] as int?,
      replyMessageCount: json['ReplyMessageCount'] as int?,
      parentGUIID: json['ParentGUIID'] as String?,
      lastInboxMessageID: json['LastInboxMessageID'] as int?,
      unreadMessageCount: json['UnreadMessageCount'] as int?,
      userID: json['UserID'] as int?,
      pageSize: json['pageSize'] as int?,
      pageNumber: json['pageNumber'] as int?,
      messageTypeid: json['MessageTypeid'] as int?,
      totalInboxMessageCount: json['TotalInboxMessageCount'] as int?,
      totalSendboxMessageCount: json['TotalSendboxMessageCount'] as int?,
      totalDraftMessageCount: json['TotalDraftMessageCount'] as int?,
      totalTrashMessageCount: json['TotalTrashMessageCount'] as int?,
    );

Map<String, dynamic> _$GetMessageDetailByMessageIdDataToJson(
        GetMessageDetailByMessageIdData instance) =>
    <String, dynamic>{
      'MessageID': instance.messageID,
      'SenderUserID': instance.senderUserID,
      'ReceiverUserID': instance.receiverUserID,
      'FkMessageTypeID': instance.fkMessageTypeID,
      'MessageTypeName': instance.messageTypeName,
      'MessageFrom': instance.messageFrom,
      'MessageTo': instance.messageTo,
      'MessageSubject': instance.messageSubject,
      'MessageBody': instance.messageBody,
      'CreatedDateTime': instance.createdDateTime,
      'IsViewed': instance.isViewed,
      'IsDeleted': instance.isDeleted,
      'TotalRecords': instance.totalRecords,
      'PageFrom': instance.pageFrom,
      'PageTo': instance.pageTo,
      'LoginUserID': instance.loginUserID,
      'SenderUserName': instance.senderUserName,
      'ReceiverUserName': instance.receiverUserName,
      'AttachmentFiles': instance.attachmentFiles,
      'MessageCreatedDateTime': instance.messageCreatedDateTime,
      'MessageTree': instance.messageTree?.map((e) => e.toJson()).toList(),
      'ReplyMessageID': instance.replyMessageID,
      'FKMessageID': instance.fKMessageID,
      'UserNameCc': instance.userNameCc,
      'MsgResponseTypeID': instance.msgResponseTypeID,
      'ReplyMessageCount': instance.replyMessageCount,
      'ParentGUIID': instance.parentGUIID,
      'LastInboxMessageID': instance.lastInboxMessageID,
      'UnreadMessageCount': instance.unreadMessageCount,
      'UserID': instance.userID,
      'pageSize': instance.pageSize,
      'pageNumber': instance.pageNumber,
      'MessageTypeid': instance.messageTypeid,
      'TotalInboxMessageCount': instance.totalInboxMessageCount,
      'TotalSendboxMessageCount': instance.totalSendboxMessageCount,
      'TotalDraftMessageCount': instance.totalDraftMessageCount,
      'TotalTrashMessageCount': instance.totalTrashMessageCount,
    };

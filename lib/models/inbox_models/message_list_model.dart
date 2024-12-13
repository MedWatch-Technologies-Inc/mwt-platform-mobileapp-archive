class MessageListModel {
  bool? result;
  int? unreadMessageCount;
  int? totalMessageCount;
  int? totalSendboxMessageCount;
  int? totalTrashMessageCount;
  int? totalInboxMessageCount;
  List<InboxData>? data;

  MessageListModel(
      {this.result,
      this.unreadMessageCount,
      this.totalMessageCount,
      this.data,
      this.totalSendboxMessageCount,
      this.totalTrashMessageCount,
      this.totalInboxMessageCount});

  MessageListModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    unreadMessageCount = json['UnreadMessageCount'];
    totalMessageCount = json['TotalMessageCount'];
    totalSendboxMessageCount = json['TotalSendboxMessageCount'];
    totalTrashMessageCount = json['TotalTrashMessageCount'];
    totalInboxMessageCount = json['TotalInboxMessageCount'];
    if (json['Data'] != null) {
      data = <InboxData>[];
      json['Data'].forEach((v) {
        data?.add(new InboxData.fromJson(v));
      });
    }
  }
}

class MessageDetailListModel {
  bool? result;
  int? id;
  InboxData? data;

  MessageDetailListModel({this.result, this.id, this.data});

  MessageDetailListModel.fromJson(Map<String, dynamic> json) {
    try {
      result = json['Result'];
      id = json['ID'];
      data = json['Data'] != null ? new InboxData.fromJson(json['Data']) : null;

      print(data);
    } catch (e) {
      print('ERROR WHILE DES.');
      print(e);
    }
  }
}

class InboxData {
  int? messageID;
  int? senderUserID;
  int? receiverUserID;
  int? fkMessageTypeID;
  String? messageTypeName;
  String? messageFrom;
  String? messageTo;
  String? messageCc;
  String? messageSubject;
  String? messageBody;
  String? createdDateTime;
  String? createdDateTimeStamp;
  bool? isViewed;
  bool? isDeleted;
  int? totalRecords;
  int? pageFrom;
  int? pageTo;
  String? userEmailTo;
  String? userEmailCc;
  int? loginUserID;
  String? loginUserEmail;
  String? senderUserName;
  String? receiverUserName;
  int? id = -1;

  int? messageType = -1;
  int? isSync = -1;
  int? userId = -1;
  bool? isSelected = false;
  String? requestType;
  String? fileExtension; //list to String
  String? userFile; //list to
  int? msgResponseTypeID;
  List<InboxData>? messageTree = [];

  String? lstemilto;
  String? lstemilCc;
  String? fileAttachments;
  List<dynamic>? attachmentFiles = [];
  int? filesids;
  String? messageCreatedDateTime;
  int? replyMessageID;
  int? fKReplyTypeID;
  int? fKMessageID;
  int? msgResponseType;
  int? messageReturnIDs;
  String? userNameCc;
  String? replyMessageTo;
  int? replyMessageCount;
  String? parentGUIID;
  int? lastInboxMessageID;
  int? unreadMessageCount;
  int? isViewedSync = 0;
  String? senderPicture;
  String? receiverPicture;
  int? totalInboxMessageCount;
  int? totalSendboxMessageCount;
  int? totalTrashMessageCount;

  InboxData({
    this.messageID,
    this.senderUserID,
    this.receiverUserID,
    this.fkMessageTypeID,
    this.messageTypeName,
    this.messageFrom,
    this.messageTo,
    this.messageCc,
    this.messageSubject,
    this.messageBody,
    this.createdDateTime,
    this.isViewed,
    this.isDeleted,
    this.totalRecords,
    this.pageFrom,
    this.pageTo,
    this.userEmailTo,
    this.userEmailCc,
    this.loginUserID,
    this.loginUserEmail,
    this.senderUserName,
    this.receiverUserName,
    this.requestType,
    this.lstemilto,
    this.lstemilCc,
    this.fileAttachments,
    this.attachmentFiles,
    this.filesids,
    this.messageCreatedDateTime,
    this.replyMessageID,
    this.fKReplyTypeID,
    this.msgResponseType,
    this.fKMessageID,
    this.messageReturnIDs,
    this.userNameCc,
    this.replyMessageTo,
    this.replyMessageCount,
    this.parentGUIID,
    this.lastInboxMessageID,
    this.unreadMessageCount,
    this.messageType,
    this.userId,
    this.isSync,
    this.fileExtension,
    this.userFile,
    this.msgResponseTypeID,
    this.messageTree,
    this.createdDateTimeStamp,
  });

  InboxData.fromJson(Map<String, dynamic> json) {
    if (json['MessageTree'] != null) {
      messageTree = <InboxData>[];
      var list = json['MessageTree'] as List<dynamic>; //as List<dynamic>
      List<InboxData> tempList = [];
      for (var i in list) {
        messageTree?.add(InboxData.fromJson(i));
      }
    }

    messageID = json['MessageID'];
    senderUserID = json['SenderUserID'];
    receiverUserID = json['ReceiverUserID'];
    fkMessageTypeID = json['FkMessageTypeID'];
    messageTypeName = json['MessageTypeName'];
    messageFrom = json['MessageFrom'];
    messageTo = json['MessageTo'];
    messageCc = json['MessageCc'];
    messageSubject = json['MessageSubject'];
    messageBody = json['MessageBody'];
    createdDateTime = json['CreatedDateTime'];
    isViewed = json['IsViewed'];
    isDeleted = json['IsDeleted'];
    totalRecords = json['TotalRecords'];
    pageFrom = json['PageFrom'];
    pageTo = json['PageTo'];
    userEmailTo = json['UserEmailTo'];
    userEmailCc = json['UserEmailCc'];
    loginUserID = json['LoginUserID'];
    loginUserEmail = json['LoginUserEmail'];
    senderUserName = json['SenderUserName'];
    receiverUserName = json['ReceiverUserName'];
    requestType = json['RequestType'];
    fileExtension =
        json['FileExtension'] != null ? json['FileExtension'] : null;
    userFile = json['UserFile'] != null ? json['UserFile'] : null;
    msgResponseTypeID = json['MsgResponseTypeID'];

    lstemilto = json['lstemilto'];
    lstemilCc = json['lstemilCc'];
    fileAttachments = json['FileAttachments'];
    attachmentFiles =
        json['AttachmentFiles'] != null ? json['AttachmentFiles'] : null;
    filesids = json['Filesids'];
    messageCreatedDateTime = json['MessageCreatedDateTime'];
    msgResponseType = json['MsgResponseType'];
    replyMessageID = json['ReplyMessageID'];
    fKReplyTypeID = json['FKReplyTypeID'];
    fKMessageID = json['FKMessageID'];
    messageReturnIDs = json['MessageReturnIDs'];
    userNameCc = json['UserNameCc'];
    replyMessageTo = json['ReplyMessageTo'];
    replyMessageCount = json['ReplyMessageCount'];
    parentGUIID = json['ParentGUIID'];
    lastInboxMessageID = json['LastInboxMessageID'];
    unreadMessageCount =
        json['UnreadMessageCount'] != null ? json['UnreadMessageCount'] : null;
    receiverPicture = json['RecivarPicture'];
    senderPicture = json['SenderPicture'];
    totalInboxMessageCount = json['TotalInboxMessageCount'];
    totalSendboxMessageCount = json['TotalSendboxMessageCount'];
    totalTrashMessageCount = json['TotalTrashMessageCount'];
    createdDateTimeStamp = json['CreatedDateTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MessageID'] = messageID;
    data['SenderUserID'] = senderUserID;
    data['ReceiverUserID'] = receiverUserID;
    data['FkMessageTypeID'] = fkMessageTypeID;
    data['MessageTypeName'] = messageTypeName;
    data['MessageFrom'] = messageFrom;
    data['MessageTo'] = messageTo;
    data['MessageCc'] = messageCc;
    data['MessageSubject'] = messageSubject;
    data['MessageBody'] = messageBody;
    data['CreatedDateTime'] = createdDateTime;
    data['IsViewed'] = isViewed;
    data['IsDeleted'] = isDeleted;
    data['TotalRecords'] = totalRecords;
    data['PageFrom'] = pageFrom;
    data['PageTo'] = pageTo;
    data['UserEmailTo'] = userEmailTo;
    data['UserEmailCc'] = userEmailCc;
    data['LoginUserID'] = loginUserID;
    data['LoginUserEmail'] = loginUserEmail;
    data['SenderUserName'] = senderUserName;
    data['ReceiverUserName'] = receiverUserName;
    data['RequestType'] = requestType;
    data['FileExtension'] = fileExtension != null ? fileExtension : null;
    data['UserFile'] = userFile != null ? userFile : null;
    data['MsgResponseTypeID'] = msgResponseTypeID;

    data['lstemilto'] = lstemilto;
    data['lstemilCc'] = lstemilCc;
    data['FileAttachments'] = fileAttachments;
//    data['AttachmentFiles'] = this.attachmentFiles!= null? this.attachmentFiles: null;
    data['Filesids'] = filesids;
    data['MessageCreatedDateTime'] = messageCreatedDateTime;
    data['MsgResponseType'] = msgResponseType;
    data['ReplyMessageID'] = replyMessageID;
    data['FKReplyTypeID'] = fKReplyTypeID;
    data['FKMessageID'] = fKMessageID;
    data['MessageReturnIDs'] = messageReturnIDs;
    data['UserNameCc'] = userNameCc;
    data['ReplyMessageTo'] = replyMessageTo;
    data['ReplyMessageCount'] = replyMessageCount;
    data['ParentGUIID'] = parentGUIID;
    data['LastInboxMessageID'] = lastInboxMessageID;
    data['UnreadMessageCount'] = unreadMessageCount;

    data['MessageTree'] = messageTree != null
        ? messageTree?.map((v) => v.toJson()).toList()
        : null;

    return data;
  }

  Map<String, dynamic> toJsonToInsertInDb(int isRead, int isRemoved) => {
        'UserId': userId,
        'MessageID': messageID,
        'SenderUserID': senderUserID,
        'ReceiverUserID': receiverUserID,
        'FkMessageTypeID': fkMessageTypeID,
        'MessageTypeName': messageTypeName,
        'MessageFrom': messageFrom,
        'MessageTo': messageTo,
        'MessageCc': messageCc,
        'MessageSubject': messageSubject,
        'MessageBody': messageBody,
        'CreatedDateTime': createdDateTime,
        'IsViewed': isRead,
        'IsDeleted': isRemoved,
        'TotalRecords': totalRecords,
        'PageFrom': pageFrom,
        'PageTo': pageTo,
        'UserEmailTo': userEmailTo,
        'UserEmailCc': userEmailCc,
        'LoginUserID': loginUserID,
        'LoginUserEmail': loginUserEmail,
        'SenderUserName': senderUserName,
        'ReceiverUserName': receiverUserName,
        'MessageType': messageType,
        'IsSync': isSync,

        'FileExtension': fileExtension,
        'UserFile': userFile,

//    'RequestType' : this.requestType,////////////////////////////
//    'FileExtension' : jsonEncode(this.fileExtension),
//    'UserFile' : jsonEncode(this.userFile),

        'MsgResponseTypeID': msgResponseTypeID,

        'lstemilto': lstemilto,
        'lstemilCc': lstemilCc,
        'FileAttachments': fileAttachments,
        // 'AttachmentFiles' : jsonEncode(this.attachmentFiles)!= null? jsonEncode(this.attachmentFiles): null,
        'Filesids': filesids,
        'MessageCreatedDateTime': messageCreatedDateTime,
        'MsgResponseType': msgResponseType,
        'ReplyMessageID': replyMessageID,
        'FKReplyTypeID': fKReplyTypeID,
        'FKMessageID': fKMessageID,
        'MessageReturnIDs': messageReturnIDs,
        'UserNameCc': userNameCc,
        'ReplyMessageTo': replyMessageTo,
        'ReplyMessageCount': replyMessageCount,
        'ParentGUIID': parentGUIID,
        'LastInboxMessageID': lastInboxMessageID,
        'UnreadMessageCount': unreadMessageCount,
        'RecivarPicture': receiverPicture,
        'SenderPicture': senderPicture,
        'TotalInboxMessageCount': totalInboxMessageCount,
        'TotalSendboxMessageCount': totalSendboxMessageCount,
        'TotalTrashMessageCount': totalTrashMessageCount,
        'CreatedDateTimeStamp': createdDateTimeStamp,
//    'MessageTree' : jsonEncode(this.messageTree)
      };

  InboxData.fromMap(Map map) {
    if (check('MessageID', map)) {
      messageID = map['MessageID'];
    }
    if (check('SenderUserID', map)) {
      senderUserID = map['SenderUserID'];
    }
    if (check('ReceiverUserID', map)) {
      receiverUserID = map['ReceiverUserID'];
    }
    if (check('FkMessageTypeID', map)) {
      fkMessageTypeID = map['FkMessageTypeID'];
    }
    if (check('MessageTypeName', map)) {
      messageTypeName = map['MessageTypeName'];
    }
    if (check('MessageFrom', map)) {
      messageFrom = map['MessageFrom'];
    }
    if (check('MessageTo', map)) {
      messageTo = map['MessageTo'];
    }
    if (check('MessageCc', map)) {
      messageCc = map['MessageCc'];
    }
    if (check('MessageSubject', map)) {
      messageSubject = map['MessageSubject'];
    }
    if (check('MessageBody', map)) {
      messageBody = map['MessageBody'];
    }
    if (check('CreatedDateTime', map)) {
      createdDateTime = map['CreatedDateTime'];
    }
    if (check('IsViewed', map)) {
      if (map['IsViewed'] == 1) {
        isViewed = true;
      } else {
        isViewed = false;
      }
    }
    if (check('IsDeleted', map)) {
      if (map['IsDeleted'] == 1) {
        isDeleted = true;
      } else {
        isDeleted = false;
      }
    }
    if (check('TotalRecords', map)) {
      totalRecords = map['TotalRecords'];
    }
    if (check('PageFrom', map)) {
      pageFrom = map['PageFrom'];
    }
    if (check('PageTo', map)) {
      pageTo = map['PageTo'];
    }

    if (check('UserEmailTo', map)) {
      userEmailTo = map['UserEmailTo'];
    }

    if (check('UserEmailCc', map)) {
      userEmailCc = map['UserEmailCc'];
    }
    if (check('LoginUserID', map)) {
      loginUserID = map['LoginUserID'];
    }
    if (check('LoginUserEmail', map)) {
      loginUserEmail = map['LoginUserEmail'];
    }
    if (check('SenderUserName', map)) {
      senderUserName = map['SenderUserName'];
    }
    if (check('ReceiverUserName', map)) {
      receiverUserName = map['ReceiverUserName'];
    }
    if (check('Id', map)) {
      id = map['Id'];
    }
    if (check('MessageType', map)) {
      messageType = map['MessageType'];
    }
    if (check('IsSync', map)) {
      isSync = map['IsSync'];
    }
    if (check('UserId', map)) {
      userId = map['UserId'];
    }

//    if (check("RequestType", map)) {////////////////////////////////////
//      requestType = map["RequestType"];
//    }
    if (check('FileExtension', map)) {
      fileExtension = map['FileExtension'];
    }
    if (check('UserFile', map)) {
      userFile = map['UserFile'];
    }
    if (check('MsgResponseTypeID', map)) {
      msgResponseTypeID = map['MsgResponseTypeID'];
    }
//
//    //
    if (check('lstemilto', map)) {
      lstemilto = map['lstemilto'];
    }
    if (check('lstemilCc', map)) {
      lstemilCc = map['lstemilCc'];
    }
    if (check('FileAttachments', map)) {
      fileAttachments = map['FileAttachments'];
    }
    if (check('AttachmentFiles', map)) {
      //[]
      attachmentFiles = map['AttachmentFiles'];
    }
    if (check('Filesids', map)) {
      filesids = map['Filesids'];
    }
    if (check('MessageCreatedDateTime', map)) {
      messageCreatedDateTime = map['MessageCreatedDateTime'];
    }
    if (check('MsgResponseType', map)) {
      msgResponseType = map['MsgResponseType'];
    }
    if (check('ReplyMessageID', map)) {
      replyMessageID = map['ReplyMessageID'];
    }
    if (check('FKReplyTypeID', map)) {
      fKReplyTypeID = map['FKReplyTypeID'];
    }
    if (check('FKMessageID', map)) {
      fKMessageID = map['FKMessageID'];
    }
    if (check('MessageReturnIDs', map)) {
      messageReturnIDs = map['MessageReturnIDs'];
    }
    if (check('UserNameCc', map)) {
      userNameCc = map['UserNameCc'];
    }
    if (check('ReplyMessageTo', map)) {
      replyMessageTo = map['ReplyMessageTo'];
    }
    if (check('ReplyMessageCount', map)) {
      replyMessageCount = map['ReplyMessageCount'];
    }
    if (check('ParentGUIID', map)) {
      parentGUIID = map['ParentGUIID'];
    }
    if (check('LastInboxMessageID', map)) {
      lastInboxMessageID = map['LastInboxMessageID'];
    }
    if (check('UnreadMessageCount', map)) {
      unreadMessageCount = map['UnreadMessageCount'];
    }
    if (check('RecivarPicture', map)) {
      receiverPicture = map['RecivarPicture'];
    }
    if (check('SenderPicture', map)) {
      senderPicture = map['SenderPicture'];
    }
    if (check('TotalInboxMessageCount', map)) {
      totalInboxMessageCount = map['TotalInboxMessageCount'];
    }
    if (check('TotalSendboxMessageCount', map)) {
      totalSendboxMessageCount = map['TotalSendboxMessageCount'];
    }
    if (check('TotalTrashMessageCount', map)) {
      totalTrashMessageCount = map['TotalTrashMessageCount'];
    }

//    if (check("MessageTree", map)) {
//      messageTree = jsonDecode(map["MessageTree"]);
//    }
  }

  bool check(String key, Map map) {
    if (map != null && map.containsKey(key) && map[key] != null) {
      if (map[key] is String && map[key] == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }
}

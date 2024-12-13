class GroupAccessChatHistoryModel {
  late bool result;
  late int response;
  late List<GroupChatMessageData> data;

  GroupAccessChatHistoryModel(
      {required this.result, required this.response, required this.data});

  GroupAccessChatHistoryModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    data = <GroupChatMessageData>[];
    if (json['Data'] != null && response == 200) {
      json['Data'].forEach((v) {
        data.add(new GroupChatMessageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Response'] = this.response;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupChatMessageData {
  int? messageId;
  String? message;
  String? dateSent;
  Null dateSentString;
  String? fromUsername;
  Null toUsername;
  int? isSent;

  GroupChatMessageData(
      {this.messageId,
      this.message,
      this.dateSent,
      this.dateSentString,
      this.fromUsername,
      this.toUsername,
      this.isSent});

  GroupChatMessageData.fromJson(Map<String, dynamic> json) {
    messageId = json['MessageId'];
    message = json['Message'];
    dateSent = json['DateSent'];
    fromUsername = json['FromUsername'];
    toUsername = json['ToUsername'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MessageId'] = this.messageId;
    data['Message'] = this.message;
    data['DateSent'] = this.dateSent;
    data['FromUsername'] = this.fromUsername;
    data['ToUsername'] = this.toUsername;
    return data;
  }

  Map<String, dynamic> toJsonToInsertInDb() => {
        'MessageId': this.messageId,
        'Message': this.message,
        'DateSent': this.dateSent,
        'FromUsername': this.fromUsername,
        'ToUsername': this.toUsername,
        'IsSent': this.isSent,
      };
  GroupChatMessageData.fromMap(Map map) {
    try {
      if (check('MessageId', map)) {
        messageId = map['MessageId'];
      }
      if (check('Message', map)) {
        message = map['Message'];
      }
      if (check('DateSent', map)) {
        dateSent = map['DateSent'];
      }
      if (check('FromUserName', map)) {
        fromUsername = map['FromUserName'];
      }
      if (check('ToUserName', map)) {
        toUsername = map['ToUserName'];
      }
      if (check('IsSent', map)) {
        isSent = map['IsSent'];
      }
    } catch (e) {
      print(e);
    }
  }

  check(String key, Map map) {
    if (map.containsKey(key) && map[key] != null) {
      if (map[key] is String && map[key] == "null") {
        return false;
      }
      return true;
    }
    return false;
  }
}






//
//
// class GroupAccessChatHistoryModel {
//   bool result;
//   int response;
//   List<GroupChatMessageData> data;
//
//   GroupAccessChatHistoryModel({this.result, this.response, this.data});
//
//   GroupAccessChatHistoryModel.fromJson(Map<String, dynamic> json) {
//     result = json['Result'];
//     response = json['Response'];
//     data = new List<GroupChatMessageData>();
//     if (json['Data'] != null && response == 200) {
//       json['Data'].forEach((v) {
//         data.add(new GroupChatMessageData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Result'] = this.result;
//     data['Response'] = this.response;
//     if (this.data != null) {
//       data['Data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class GroupChatMessageData {
//   String message;
//   String dateSent;
//   String fromUsername;
//   Null toUsername;
//   int isSent = 1;
//
//   GroupChatMessageData(
//       {this.message,
//       this.dateSent,
//       this.fromUsername,
//       this.toUsername,
//       this.isSent});
//
//   GroupChatMessageData.fromJson(Map<String, dynamic> json) {
//     message = json['Message'];
//     dateSent = json['DateSent'];
//     fromUsername = json['FromUsername'];
//     toUsername = json['ToUsername'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Message'] = this.message;
//     data['DateSent'] = this.dateSent;
//     data['FromUsername'] = this.fromUsername;
//     data['ToUsername'] = this.toUsername;
//     return data;
//   }
//
//   Map<String, dynamic> toJsonToInsertInDb() => {
//         'Message': this.message,
//         'DateSent': this.dateSent,
//         'FromUserName': this.fromUsername,
//         'ToUserName': this.toUsername,
//         'IsSent': this.isSent,
//       };
//   //
//   // GroupChatMessageData.fromMap(Map map) {
//   //   try {
//   //     if (check('Message', map)) {
//   //       message = map['Message'];
//   //     }
//   //     if (check('DateSent', map)) {
//   //       dateSent = map['DateSent'];
//   //     }
//   //     if (check('FromUserName', map)) {
//   //       fromUsername = map['FromUserName'];
//   //     }
//   //     if (check('ToUserName', map)) {
//   //       toUsername = map['ToUserName'];
//   //     }
//   //     if (check('IsSent', map)) {
//   //       isSent = map['IsSent'];
//   //     }
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }
//
//   check(String key, Map map) {
//     if (map != null && map.containsKey(key) && map[key] != null) {
//       if (map[key] is String && map[key] == "null") {
//         return false;
//       }
//       return true;
//     }
//     return false;
//   }
// }

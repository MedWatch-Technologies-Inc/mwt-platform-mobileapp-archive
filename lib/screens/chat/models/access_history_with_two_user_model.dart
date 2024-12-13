import 'package:intl/intl.dart';

class AccessHistoryWithTwoUserModel {
  late bool result;
  int? response;
  List<ChatMessageData>? data;

  AccessHistoryWithTwoUserModel(
      {required this.result, this.response, this.data});

  AccessHistoryWithTwoUserModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    data = <ChatMessageData>[];
    if (json['Data'] != null && json['Data'] != "") {
      json['Data'].forEach((v) {
        data?.add(ChatMessageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Response'] = this.response;
    if (this.data != null) {
      data['Data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// import 'package:intl/intl.dart';

class ChatMessageData {
  String? message;
  late String dateSent;
  String? fromUsername;
  String? toUsername;
  int? fromUserId;
  int? toUserId;
  int? id;
  int? isSent = 1;
  int? timestamp;

  ChatMessageData(
      {this.message,
      required this.dateSent,
      this.fromUsername,
      this.toUsername,
      this.toUserId,
      this.fromUserId,
      this.isSent,
      this.timestamp});

  ChatMessageData.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    dateSent = UTCtoIST(json['DateSent'].toString());
    // dateSent = json['DateSent'];
    fromUsername = json['FromUsername'];
    toUsername = json['ToUsername'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['DateSent'] = this.dateSent;
    data['FromUsername'] = this.fromUsername;
    data['ToUsername'] = this.toUsername;
    return data;
  }

  String UTCtoIST(String utcDate) {
    DateTime dateTime = DateTime.now();
    print(dateTime.timeZoneName);

    var utcDateTime = DateTime.parse(utcDate);
    var istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
    // var istDateTime = utcDateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    var formattedISTDate =
        DateFormat('yyyy-MM-ddTHH:mm:ss.S').format(istDateTime);
    // print(" mesg ::: mesg :::${utcDate} ${formattedISTDate} ");
    // print("UTC Date: $utcDate");
    // print("IST Date: $formattedISTDate");
    // print("IST Date: ${istDateTime.toString()}");
    return dateTime.timeZoneName == 'IST' ? formattedISTDate : utcDate;
  }

  Map<String, dynamic> toJsonToInsertInDb() => {
        'id': this.id,
        'FromUserId': this.fromUserId,
        'ToUserId': this.toUserId,
        'Message': this.message,
        'DateSent': this.dateSent,
        'FromUserName': this.fromUsername,
        'ToUserName': this.toUsername,
        'IsSent': this.isSent,
      };

  ChatMessageData.fromMap(Map map) {
    try {
      if (check('id', map)) {
        id = map['id'];
      }
      if (check('ToUserId', map)) {
        toUserId = map['ToUserId'];
      }
      if (check('FromUserId', map)) {
        fromUserId = map['FromUserId'];
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
    if (map != null && map.containsKey(key) && map[key] != null) {
      if (map[key] is String && map[key] == "null") {
        return false;
      }
      return true;
    }
    return false;
  }
}

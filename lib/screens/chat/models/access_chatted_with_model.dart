import 'package:health_gauge/repository/chat/model/access_chatted_with_result.dart';

class AccessChattedWithModel {
  bool? result;
  int? response;
  List<ChatUserData>? data;

  AccessChattedWithModel({this.result, this.response, this.data});

  // AccessChattedWithModel.fromJson(Map<String, dynamic> json) {
  //   result = json['Result'];
  //   response = json['Response'];
  //   if (json['Data'] != null) {
  //     data = <ChatUserData>[];
  //     if (json['Data'] != '') {
  //       json['Data'].forEach((v) {
  //         data!.add(ChatUserData.fromJson(v));
  //       });
  //     }
  //   }
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['Result'] = result;
  //   data['Response'] = response;
  //   if (this.data != null) {
  //     data['Data'] = this.data!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }

  static AccessChattedWithModel map(AccessChattedWithResult obj) {
    var model = AccessChattedWithModel()
      ..result = obj.result
      ..response = obj.response
      ..data = obj.data != null
          ? List<ChatUserData>.from(obj.data!.map((e) => ChatUserData()
            ..lastName = e.lastName!
            ..firstName = e.firstName!
            ..userID = e.userID
            ..username = e.username
            ..groupName = e.groupName
            ..isGroup = e.isGroup
            ..members = e.members
            ..toUserId = e.toUserId
            ..id = e.id))
          : null;
    return model;
  }
}

class ChatUserData {
  int? userID;
  String? firstName;
  String? lastName;
  String? username;
  int? id;
  int? isGroup = 0;
  String? members = '';
  int? toUserId;
  String? groupName;
  String? picture;


  ChatUserData(
      {this.userID,
      this.firstName,
      this.lastName,
      this.username,
      this.id,
      this.toUserId,
      this.groupName,
      this.isGroup,
      this.members,
      this.picture
      });

  // ChatUserData.fromJson(Map<String, dynamic> json) {
  //   userID = json['UserID'];
  //   firstName = json['FirstName'];
  //   lastName = json['LastName'];
  //   username = json['Username'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['UserID'] = userID;
  //   data['FirstName'] = firstName;
  //   data['LastName'] = lastName;
  //   data['Username'] = username;
  //   return data;
  // }

  Map<String, dynamic> toJsonToInsertInDb() => {
        'id': id,
        'IsGroup': isGroup,
        'Members': members,
        'FromUserId': userID,
        'FromFirstName': firstName,
        'FromLastName': lastName,
        'ToUserId': toUserId,
        'GroupName': groupName,
        'userName': username,
        'picture': picture,
      };

  ChatUserData.fromMap(Map map) {
    try {
      if (check('id', map)) {
        id = map['id'];
      }
      if (check('IsGroup', map)) {
        isGroup = map['IsGroup'];
      }
      if (check('Members', map)) {
        members = map['Members'];
      }
      if (check('FromUserId', map)) {
        userID = map['FromUserId'];
      }
      if (check('FromFirstName', map)) {
        firstName = map['FromFirstName'];
      }
      if (check('FromLastName', map)) {
        lastName = map['FromLastName'];
      }
      if (check('ToUserId', map)) {
        toUserId = map['ToUserId'];
      }
      if (check('GroupName', map)) {
        groupName = map['GroupName'];
      }
      if (check('userName', map)) {
        username = map['userName'];
      }if (check('picture', map)) {
        picture = map['picture'];
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  bool check(String key, Map? map) {
    if (map != null && map.containsKey(key) && map[key] != null) {
      if (map[key] is String && map[key] == "null") {
        return false;
      }
      return true;
    }
    return false;
  }
}

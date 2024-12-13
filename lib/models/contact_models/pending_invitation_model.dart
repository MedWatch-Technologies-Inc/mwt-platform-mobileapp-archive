class PendingInvitationModel {
  bool? result;
  int? response;
  List<InvitationList>? invitationList;
  bool? isFromDb;

  PendingInvitationModel({this.result, this.response, this.invitationList,this.isFromDb});

  PendingInvitationModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      invitationList = <InvitationList>[];
      json['Data'].forEach((v) {
        invitationList?.add(new InvitationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Result'] = result;
    data['Response'] = response;
    if (invitationList != null) {
      data['Data'] = invitationList?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvitationList {
  int? contactID;
  int? senderUserID;
  String? senderFirstName;
  String? senderLastName;
  String? senderEmail;
  String? senderPhone;
  String? senderPicture;
  bool? isAccepted;
  int? isSync;
  int? userId;

  InvitationList(
      {this.contactID,
        this.senderUserID,
        this.senderFirstName,
        this.senderLastName,
        this.senderEmail,
        this.senderPhone,
        this.senderPicture,
        this.isAccepted,
        this.isSync,
        this.userId});

  InvitationList.fromJson(Map<String, dynamic> json) {
    contactID = json['ContactID'];
    senderUserID = json['SenderUserID'];
    senderFirstName = json['SenderFirstName'];
    senderLastName = json['SenderLastName'];
    senderEmail = json['SenderEmail'];
    senderPhone = json['SenderPhone'];
    senderPicture = json['SenderPicture'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ContactID'] = contactID;
    data['SenderUserID'] = senderUserID;
    data['SenderFirstName'] = senderFirstName;
    data['SenderLastName'] = senderLastName;
    data['SenderEmail'] = senderEmail;
    data['SenderPhone'] = senderPhone;
    data['SenderPicture'] = senderPicture;
    return data;
  }

  Map<String, dynamic> toJsonToInsertInDb(int isAccepted) =>
      {
        'ContactID': contactID,
        'SenderUserID': senderUserID,
        'SenderFirstName': senderFirstName,
        'SenderLastName': senderLastName,
        'SenderEmail': senderEmail,
        'SenderPhone': senderPhone,
        'SenderPicture': senderPicture,
        'IsAccepted': isAccepted,
        'IsSync': isSync,
        'UserId': userId
      };

  InvitationList.fromMap(Map map) {
    if (check('ContactID', map)) {
      contactID = map['ContactID'];
    }
    if (check('SenderUserID', map)) {
      senderUserID = map['SenderUserID'];
    }

    if (check('SenderFirstName', map)) {
      senderFirstName = map['SenderFirstName'];
    }
    if (check('SenderLastName', map)) {
      senderLastName = map['SenderLastName'];
    }
    if (check('SenderEmail', map)) {
      senderEmail = map['SenderEmail'];
    }
    if (check('SenderPhone', map)) {
      senderPhone = map['SenderPhone'];
    }
    if (check('SenderPicture', map)) {
      senderPicture = map['SenderPicture'];
    }
    if (check('IsAccepted', map)) {
      if (map['IsAccepted'] == 1) {
        isAccepted = true;
      } else {
        isAccepted = false;
      }
    }
    if (check('IsSync', map)) {
      isSync = map['IsSync'];
    }
    if (check('UserId', map)) {
      userId = map['UserId'];
    }
  }

  bool check(String key, Map? map) {
    if (map != null && map.containsKey(key) && map[key] != null) {
      if (map[key] is String && map[key] == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }
}
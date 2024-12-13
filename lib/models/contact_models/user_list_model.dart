class UserListModel {
  bool? result;
  int? response;
  bool? isFromDb;
  List<UserData>? data;

  UserListModel({this.result, this.response, this.data, this.isFromDb});

  UserListModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      data = <UserData>[];
      json['Data'].forEach((v) {
        data?.add(new UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = result;
    data['Response'] = response;
    if (this.data != null) {
      data['Data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  int? contactID;
  int? fKSenderUserID;
  int? fKReceiverUserID;
  String? username;
  String? firstName;
  String? lastName;
  String? senderFirstName;
  String? senderLastName;
  String? senderEmail;
  String? senderPhone;
  String? senderPicture;
  String? receiverFirstName;
  String? receiverLastName;
  String? receiverEmail;
  String? receiverPhone;
  String? receiverPicture;
  String? email;
  String? phone;
  String? picture;
  bool? isDeleted;
  Null? contactGuid;
  bool? isAccepted;
  bool? isRejected;
  bool isSelected = false; //used to show if contact is selected in the list
  String? createdDatetime;
  String? createdDatetimeString;
  int? pageNumber;
  int? pageSize;
  int? totalRecords;
  int? isSync;
  int? id;

  UserData(
      {this.contactID,
      this.fKSenderUserID,
      this.fKReceiverUserID,
      this.username,
      this.firstName,
      this.lastName,
      this.senderFirstName,
      this.senderLastName,
      this.senderEmail,
      this.senderPhone,
      this.senderPicture,
      this.receiverFirstName,
      this.receiverLastName,
      this.receiverEmail,
      this.receiverPhone,
      this.receiverPicture,
      this.email,
      this.phone,
      this.picture,
      this.isDeleted,
      this.contactGuid,
      this.isAccepted,
      this.isRejected,
      this.createdDatetime,
      this.createdDatetimeString,
      this.pageNumber,
      this.pageSize,
      this.totalRecords});

  UserData.fromJson(Map<String, dynamic> json) {
    contactID = json['ContactID'];
    fKSenderUserID = json['SenderUserID'];
    fKReceiverUserID = json['ReceiverUserID'];
    username = json['Username'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    senderFirstName = json['SenderFirstName'];
    senderLastName = json['SenderLastName'];
    senderEmail = json['SenderEmail'];
    senderPhone = json['SenderPhone'];
    senderPicture = json['SenderPicture'];
    receiverFirstName = json['ReceiverFirstName'];
    receiverLastName = json['ReceiverLastName'];
    receiverEmail = json['ReceiverEmail'];
    receiverPhone = json['ReceiverPhone'];
    receiverPicture = json['ReceiverPicture'];
    email = json['Email'];
    phone = json['Phone'];
    picture = json['Picture'];
    isDeleted = json['IsDeleted'];
    contactGuid = json['ContactGuid'];
    isAccepted = json['IsAccepted'];
    isRejected = json['IsRejected'];
    createdDatetime = json['CreatedDatetime'];
    createdDatetimeString = json['CreatedDatetimeString'];
    pageNumber = json['PageNumber'];
    pageSize = json['PageSize'];
    totalRecords = json['TotalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContactID'] = contactID;
    data['FKSenderUserID'] = fKSenderUserID;
    data['FKReceiverUserID'] = fKReceiverUserID;
    data['Username'] = username;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['SenderFirstName'] = senderFirstName;
    data['SenderLastName'] = senderLastName;
    data['SenderEmail'] = senderEmail;
    data['SenderPhone'] = senderPhone;
    data['SenderPicture'] = senderPicture;
    data['ReceiverFirstName'] = receiverFirstName;
    data['ReceiverLastName'] = receiverLastName;
    data['ReceiverEmail'] = receiverEmail;
    data['ReceiverPhone'] = receiverPhone;
    data['ReceiverPicture'] = receiverPicture;
    data['Email'] = email;
    data['Phone'] = phone;
    data['Picture'] = picture;
    data['IsDeleted'] = isDeleted;
    data['ContactGuid'] = contactGuid;
    data['IsAccepted'] = isAccepted;
    data['IsRejected'] = isRejected;
    data['CreatedDatetime'] = createdDatetime;
    data['CreatedDatetimeString'] = createdDatetimeString;
    data['PageNumber'] = pageNumber;
    data['PageSize'] = pageSize;
    data['TotalRecords'] = totalRecords;
    return data;
  }

  Map<String, dynamic> toJsonToInsertInDb(
          int isAccepted, int isRejected, int isRemoved) =>
      {
        'ContactID': contactID,
        'FKSenderUserID': fKSenderUserID,
        'FKReceiverUserID': fKReceiverUserID,
        'Username': username,
        'FirstName': firstName,
        'LastName': lastName,
        'SenderFirstName': senderFirstName,
        'SenderLastName': senderLastName,
        'SenderEmail': senderEmail,
        'SenderPhone': senderPhone,
        'SenderPicture': senderPicture,
        'ReceiverFirstName': receiverFirstName,
        'ReceiverLastName': receiverLastName,
        'ReceiverEmail': receiverEmail,
        'ReceiverPhone': receiverPhone,
        'ReceiverPicture': receiverPicture,
        'Email': email,
        'Phone': phone,
        'Picture': picture,
        'IsDeleted': isRemoved,
        'ContactGuid': contactGuid,
        'IsAccepted': isAccepted,
        'IsRejected': isRejected,
        'CreatedDatetime': createdDatetime,
        'CreatedDatetimeString': createdDatetimeString,
        'PageNumber': pageNumber,
        'PageSize': pageSize,
        'TotalRecords': totalRecords,
        'IsSync': isSync,
      };

  UserData.fromMap(Map map) {
    if (check('ContactID', map)) {
      contactID = map['ContactID'];
    }
    if (check('FKSenderUserID', map)) {
      fKSenderUserID = map['FKSenderUserID'];
    }
    if (check('FKReceiverUserID', map)) {
      fKReceiverUserID = map['FKReceiverUserID'];
    }
    if (check('Username', map)) {
      username = map['Username'];
    }
    if (check('FirstName', map)) {
      firstName = map['FirstName'];
    }
    if (check('LastName', map)) {
      lastName = map['LastName'];
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
    if (check('ReceiverFirstName', map)) {
      receiverFirstName = map['ReceiverFirstName'];
    }

    if (check('ReceiverLastName', map)) {
      receiverLastName = map['ReceiverLastName'];
    }
    if (check('ReceiverEmail', map)) {
      receiverEmail = map['ReceiverEmail'];
    }
    if (check('ReceiverPhone', map)) {
      receiverPhone = map['ReceiverPhone'];
    }

    if (check('ReceiverPicture', map)) {
      receiverPicture = map['ReceiverPicture'];
    }

    if (check('Email', map)) {
      email = map['Email'];
    }
    if (check('Phone', map)) {
      phone = map['Phone'];
    }
    if (check('Picture', map)) {
      picture = map['Picture'];
    }

    if (check('IsDeleted', map)) {
      if (map['IsDeleted'] == 1) {
        isDeleted = true;
      } else {
        isDeleted = false;
      }
    }
    if (check('ContactGuid', map)) {
      contactGuid = map['ContactGuid'];
    }
    if (check('IsAccepted', map)) {
      if (map['IsAccepted'] == 1) {
        isAccepted = true;
      } else {
        isAccepted = false;
      }
    }
    if (check('IsRejected', map)) {
      if (map['IsRejected'] == 1) {
        isRejected = true;
      } else {
        isRejected = false;
      }
    }

    if (check('CreatedDatetime', map)) {
      createdDatetime = map['CreatedDatetime'];
    }
    if (check('CreatedDatetimeString', map)) {
      createdDatetimeString = map['CreatedDatetimeString'];
    }
    if (check('PageNumber', map)) {
      pageNumber = map['PageNumber'];
    }
    if (check('PageSize', map)) {
      pageSize = map['PageSize'];
    }
    if (check('TotalRecords', map)) {
      totalRecords = map['TotalRecords'];
    }
    if (check('IsSync', map)) {
      isSync = map['IsSync'];
    }
    if (check('Id', map)) {
      id = map['Id'];
    }
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

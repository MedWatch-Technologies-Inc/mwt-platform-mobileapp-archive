class AddUserModel {
  bool? result;
  int? response;
  List<Data>? data;

  AddUserModel({this.result, this.response, this.data});

  AddUserModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      data =  <Data>[];
      json['Data'].forEach((v) {
        data?.add(new Data.fromJson(v));
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

class Data {
  int? contactID;
  int? fKSenderUserID;
  int? fKReceiverUserID;
  String? firstName;
  String? lastName;
  String? senderFirstName;
  String? senderLastName;
  String? senderEmail;
  String? senderPhone;
  Null? senderPicture;
  String? receiverFirstName;
  String? receiverLastName;
  String? receiverEmail;
  String? receiverPhone;
  Null? receiverPicture;
  String? email;
  String? phone;
  Null? picture;
  bool? isDeleted;
  Null? contactGuid;
  bool? isAccepted;
  bool? isRejected;
  String? createdDatetime;
  int? pageNumber;
  int? pageSize;
  int? totalRecords;

  Data(
      {this.contactID,
        this.fKSenderUserID,
        this.fKReceiverUserID,
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
        this.pageNumber,
        this.pageSize,
        this.totalRecords});

  Data.fromJson(Map<String, dynamic> json) {
    contactID = json['ContactID'];
    fKSenderUserID = json['FKSenderUserID'];
    fKReceiverUserID = json['FKReceiverUserID'];
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
    pageNumber = json['PageNumber'];
    pageSize = json['PageSize'];
    totalRecords = json['TotalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContactID'] = this.contactID;
    data['FKSenderUserID'] = this.fKSenderUserID;
    data['FKReceiverUserID'] = this.fKReceiverUserID;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['SenderFirstName'] = this.senderFirstName;
    data['SenderLastName'] = this.senderLastName;
    data['SenderEmail'] = this.senderEmail;
    data['SenderPhone'] = this.senderPhone;
    data['SenderPicture'] = this.senderPicture;
    data['ReceiverFirstName'] = this.receiverFirstName;
    data['ReceiverLastName'] = this.receiverLastName;
    data['ReceiverEmail'] = this.receiverEmail;
    data['ReceiverPhone'] = this.receiverPhone;
    data['ReceiverPicture'] = this.receiverPicture;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Picture'] = this.picture;
    data['IsDeleted'] = this.isDeleted;
    data['ContactGuid'] = this.contactGuid;
    data['IsAccepted'] = this.isAccepted;
    data['IsRejected'] = this.isRejected;
    data['CreatedDatetime'] = this.createdDatetime;
    data['PageNumber'] = this.pageNumber;
    data['PageSize'] = this.pageSize;
    data['TotalRecords'] = this.totalRecords;
    return data;
  }
}
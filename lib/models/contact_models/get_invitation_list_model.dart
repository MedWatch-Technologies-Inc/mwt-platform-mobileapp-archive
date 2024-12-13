import 'package:health_gauge/repository/contact/model/get_sending_invitation_list_result.dart';

class GetInvitationListModel {
  bool? result;
  int? response;
  List<Data>? data;

  GetInvitationListModel({this.result, this.response, this.data});

  GetInvitationListModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      data = <Data>[];
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

  static GetInvitationListModel mapper(GetSendingInvitationListResult obj) {
    var model = GetInvitationListModel();
    model
      ..result = obj.result
      ..response = obj.response
      ..data = obj.data != null
          ? List<Data>.from(obj.data!.map((e) => Data()
            ..userID = e.userID
            ..lastName = e.lastName
            ..firstName = e.firstName
            ..picture = e.picture
            ..createdDatetime = e.createdDatetime))
          : [];
    return model;
  }
}

class Data {
  int? userID;
  String? firstName;
  String? lastName;
  String? picture;
  String? createdDatetime;

  Data(
      {this.userID,
      this.firstName,
      this.lastName,
      this.picture,
      this.createdDatetime});

  Data.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    picture = json['Picture'];
    createdDatetime = json['CreatedDatetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Picture'] = this.picture;
    data['CreatedDatetime'] = this.createdDatetime;
    return data;
  }
}

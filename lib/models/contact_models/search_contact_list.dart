import 'package:health_gauge/repository/contact/model/search_leads_result.dart';

class SearchContactList {
  bool? result;
  int? response;
  List<SearchedUserData>? data;

  SearchContactList({this.result, this.response, this.data});

  SearchContactList.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      data = <SearchedUserData>[];
      json['Data'].forEach((v) {
        data?.add(new SearchedUserData.fromJson(v));
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

  static SearchContactList mapper(SearchLeadsResult obj) {
    var model = SearchContactList();
    model
      ..result = obj.result
      ..response = obj.response
      ..data = obj.data != null
          ? List<SearchedUserData>.from(
              obj.data!.map((e) => SearchedUserData(isSendingInvitation: false)
                ..picture = e.picture
                ..firstName = e.firstName
                ..lastName = e.lastName
                ..userID = e.userID
                ..email = e.email
                ..phoneNo = e.phone))
          : [];
    return model;
  }
}

class SearchedUserData {
  int? userID;
  String? firstName;
  String? lastName;
  String? picture;
  String? email;
  String? phoneNo;
  bool isSendingInvitation = false;

  SearchedUserData(
      {this.userID,
      this.firstName,
      this.lastName,
      this.picture,
      required this.isSendingInvitation,
      this.email,
      this.phoneNo});

  SearchedUserData.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    picture = json['Picture'];
    email = json['Email'];
    phoneNo = json['Phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Picture'] = this.picture;
    return data;
  }
}

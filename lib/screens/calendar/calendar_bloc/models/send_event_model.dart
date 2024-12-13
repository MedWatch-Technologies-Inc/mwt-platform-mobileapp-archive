class AccessCalendarEventModel {
  bool? result;
  int? response;
  List<SendEventModel>? data;

  AccessCalendarEventModel({this.result, this.response, this.data});

  AccessCalendarEventModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      data = [];
      if (json['Data'] != '') {
        json['Data'].forEach((v) {
          data?.add(new SendEventModel.fromJson(v));
        });
      }
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

class SendEventModel {
  String? information;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  int? userID;
  String? location;
  String? url;
  int? allDayCheck;
  int? alertId;
  int? repedId;
  List<int>? invitedIds;

  SendEventModel(
      {this.information,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.userID,
      this.location,
      this.url,
      this.allDayCheck,
      this.alertId,
      this.repedId,
      this.invitedIds});

  SendEventModel.fromJson(Map<String, dynamic> json) {
    information = json['Information'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    userID = json['UserID'];
    location = json['Location'];
    url = json['url'];
    allDayCheck = json['AllDayCheck'];
    alertId = json['AlertId'];
    repedId = json['RepedId'];
    invitedIds = json['InvitedIds'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Information'] = this.information;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['StartTime'] = this.startTime;
    data['EndTime'] = this.endTime;
    data['UserID'] = this.userID;
    data['Location'] = this.location;
    data['url'] = this.url;
    data['AllDayCheck'] = this.allDayCheck;
    data['AlertId'] = this.alertId;
    data['RepedId'] = this.repedId;
    data['InvitedIds'] = this.invitedIds;
    return data;
  }
}

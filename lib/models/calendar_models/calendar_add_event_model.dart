class AddEventModel {
  int? userID;
  String? eventName;
  String? startDate;
  String? endDate;
  String? timeZone;
  String? startTime;
  String? endTime;
  int? eventTagUserID;
  int? setReminderID;

  AddEventModel(
      {this.userID,
        this.eventName,
        this.startDate,
        this.endDate,
        this.timeZone,
        this.startTime,
        this.endTime,
        this.eventTagUserID,
        this.setReminderID});

  AddEventModel.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    eventName = json['EventName'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    timeZone = json['TimeZone'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    eventTagUserID = json['EventTagUserID'];
    setReminderID = json['SetReminderID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['EventName'] = this.eventName;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['TimeZone'] = this.timeZone;
    data['StartTime'] = this.startTime;
    data['EndTime'] = this.endTime;
    data['EventTagUserID'] = this.eventTagUserID;
    data['SetReminderID'] = this.setReminderID;
    return data;
  }
}

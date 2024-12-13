class DeviceInfoListModel {
  bool? result;
  int? response;
  List<DeviceList>? data;

  DeviceInfoListModel({this.result, this.response, this.data});

  DeviceInfoListModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      data = <DeviceList>[];
      json['Data'].forEach((v) {
        data?.add(new DeviceList.fromJson(v));
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

class DeviceList {
  int? iD;
  int? userID;
  String? deviceName;
  String? deviceAddress;
  String? blockStatus;
  String? createdDateTime;
  String? createDateTimeStamp;

  DeviceList(
      {this.iD,
        this.userID,
        this.deviceName,
        this.deviceAddress,
        this.blockStatus,
        this.createdDateTime,
        this.createDateTimeStamp,
      });

  DeviceList.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    userID = json['UserID'];
    deviceName = json['DeviceName'];
    deviceAddress = json['DeviceAddress'];
    blockStatus = json['BlockStatus'];
    createdDateTime = json['CreatedDateTime'];
    createDateTimeStamp = json['CreateDateTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['UserID'] = this.userID;
    data['DeviceName'] = this.deviceName;
    data['DeviceAddress'] = this.deviceAddress;
    data['BlockStatus'] = this.blockStatus;
    data['CreatedDateTime'] = this.createdDateTime;
    data['CreateDateTimeStamp'] = this.createDateTimeStamp;
    return data;
  }
}
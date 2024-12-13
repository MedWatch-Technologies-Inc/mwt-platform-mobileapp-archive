import 'package:flutter/material.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';
import 'package:intl/intl.dart';

class OTHistoryModel {
  int id;
  int userID;
  num temperature;
  num oxygen;
  num cvrr;
  num hrv;
  num heartRate;
  String date;
  int timestamp;

  int dbID;

  String get getDate =>
      DateFormat(DateUtil.MMMddhhmma).format(DateTime.fromMillisecondsSinceEpoch(timestamp));

  String get getTime =>
      DateFormat(DateUtil.hmma).format(DateTime.fromMillisecondsSinceEpoch(timestamp));

  final ValueNotifier<bool> showDetails = ValueNotifier(false);

  DateTime get getDateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);

  double get getX => ((getDateTime.hour * 60) + getDateTime.minute) / 60;

  bool get isShowDetails => showDetails.value;

  set isShowDetails(bool value) {
    showDetails.value = value;
  }

  OTHistoryModel({
    required this.id,
    required this.userID,
    required this.temperature,
    required this.oxygen,
    required this.cvrr,
    required this.hrv,
    required this.heartRate,
    required this.date,
    required this.timestamp,
    this.dbID = 0,
  });

  factory OTHistoryModel.fromJson(Map<String, dynamic> json) {
    var datetime = DateTime.parse(JsonSerializableUtils.instance
        .checkString(json['CreatedDateTime'], defaultValue: DateTime.now().toString()));
    return OTHistoryModel(
      id: JsonSerializableUtils.instance.checkInt(json['StatusID']),
      userID: JsonSerializableUtils.instance.checkInt(json['FKUserID']),
      temperature: JsonSerializableUtils.instance.checkNum(json['Temperature']),
      oxygen: JsonSerializableUtils.instance.checkNum(json['Oxygen']),
      cvrr: JsonSerializableUtils.instance.checkNum(json['CVRR']),
      hrv: JsonSerializableUtils.instance.checkNum(json['HRV']),
      heartRate: JsonSerializableUtils.instance.checkNum(json['HeartRate']),
      date: JsonSerializableUtils.instance
          .checkString(json['CreatedDateTime'], defaultValue: DateTime.now().toString()),
      timestamp: JsonSerializableUtils.instance
          .checkInt(json['CreatedDateTimeStamp'], defaultValue: datetime.millisecondsSinceEpoch),
    );
  }

  factory OTHistoryModel.fromJsonSync(Map<String, dynamic> json) {
    var dateTime = JsonSerializableUtils.instance.checkDate(json['date']);
    var tempInt = JsonSerializableUtils.instance.checkInt(json['tempInt']);
    var tempDouble = JsonSerializableUtils.instance.checkInt(json['tempDouble']);
    var temperature = '$tempInt.$tempDouble';
    return OTHistoryModel(
      id: 0,
      userID: 0,
      temperature: JsonSerializableUtils.instance.checkNum(temperature),
      oxygen: JsonSerializableUtils.instance.checkNum(json['oxygen']),
      cvrr: JsonSerializableUtils.instance.checkNum(json['cvrrValue']),
      hrv: JsonSerializableUtils.instance.checkNum(json['HRV']),
      heartRate: JsonSerializableUtils.instance.checkNum(json['heartValue']),
      date: JsonSerializableUtils.instance.checkString(json['date']),
      timestamp: dateTime.millisecondsSinceEpoch,
    );
  }

  factory OTHistoryModel.fromJsonDB(Map<String, dynamic> json) {
    var datetime = DateTime.parse(JsonSerializableUtils.instance
        .checkString(json['date'], defaultValue: DateTime.now().toString()));
    return OTHistoryModel(
      id: JsonSerializableUtils.instance.checkInt(json['idForApi']),
      userID: JsonSerializableUtils.instance.checkInt(json['UserId']),
      temperature: JsonSerializableUtils.instance.checkNum(json['Temperature']),
      oxygen: JsonSerializableUtils.instance.checkNum(json['Oxygen']),
      cvrr: JsonSerializableUtils.instance.checkNum(json['CVRR']),
      hrv: JsonSerializableUtils.instance.checkNum(json['HRV']),
      heartRate: JsonSerializableUtils.instance.checkNum(json['HeartRate']),
      date: JsonSerializableUtils.instance.checkString(json['date'], defaultValue: DateTime.now().toString()),
      timestamp: JsonSerializableUtils.instance.checkInt(json['timestamp'], defaultValue: datetime.millisecondsSinceEpoch),
      dbID: JsonSerializableUtils.instance.checkInt(json['id']),
    );
  }

  Map<String, dynamic> requestJson() {
    return {
      'FKUserID': userID,
      'Oxygen': oxygen,
      'HRV': hrv,
      'CVRR': cvrr,
      'HeartRate': heartRate,
      'Temperature': temperature,
      'CreatedDateTime': date,
      'CreatedDateTimeStamp': timestamp,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'StatusID': id,
      'FKUserID': userID,
      'Temperature': temperature,
      'Oxygen': oxygen,
      'CVRR': cvrr,
      'HRV': hrv,
      'HeartRate': heartRate,
      'CreatedDateTime': date,
      'timestamp': timestamp,
    };
  }

  Map<String, dynamic> toJsonDB({bool unSync = false}) {
    return {
      'idForApi': id,
      'UserId': userID,
      'Temperature': temperature,
      'Oxygen': oxygen,
      'CVRR': cvrr,
      'HRV': hrv,
      'HeartRate': heartRate,
      'date': date,
      'timestamp': timestamp,
      if (unSync) 'id': dbID,
    };
  }

//
}

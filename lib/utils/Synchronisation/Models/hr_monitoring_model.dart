import 'package:flutter/material.dart';
import 'package:health_gauge/utils/Synchronisation/string_extension.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';
import 'package:intl/intl.dart';

class SyncHRModel {
  int id;
  int userID;
  int date;
  int approxHR;
  int zoneID;
  int dbID;

  SyncHRModel({
    required this.id,
    required this.userID,
    required this.date,
    required this.approxHR,
    required this.zoneID,
    this.dbID = 0,
  });

  String get getDate =>
      DateFormat(DateUtil.MMMddhhmma).format(DateTime.fromMillisecondsSinceEpoch(date));

  DateTime get getDateTime => DateTime.fromMillisecondsSinceEpoch(date);

  String get getTime => DateFormat(DateUtil.hmma).format(DateTime.fromMillisecondsSinceEpoch(date));

  double get getX => ((getDateTime.hour * 60) + getDateTime.minute) / 60;

  final ValueNotifier<bool> showDetails = ValueNotifier(false);

  bool get isShowDetails => showDetails.value;

  set isShowDetails(bool value) {
    showDetails.value = value;
  }

  factory SyncHRModel.fromJson(Map<String, dynamic> json) {
    return SyncHRModel(
      id: JsonSerializableUtils.instance.checkInt(json['ID']),
      userID: JsonSerializableUtils.instance.checkInt(json['userId']),
      date: JsonSerializableUtils.instance.checkInt(json['date']),
      approxHR: JsonSerializableUtils.instance.checkInt(json['hr']),
      zoneID: JsonSerializableUtils.instance.checkInt(json['ZoneID']),
    );
  }

  factory SyncHRModel.fromJsonSync(Map json) {
    var isTimeStamp = json['heartStartTime'].toString().isInt;
    return SyncHRModel(
      id: 0,
      userID: 0,
      date: isTimeStamp
          ? JsonSerializableUtils.instance.checkInt(json['heartStartTime'])
          : JsonSerializableUtils.instance.checkDate(json['heartStartTime']).millisecondsSinceEpoch,
      approxHR: JsonSerializableUtils.instance.checkInt(json['heartValue']),
      zoneID: JsonSerializableUtils.instance.checkInt(json['zoneID']),
    );
  }

  factory SyncHRModel.fromJsonDB(Map<String, dynamic> json) {
    return SyncHRModel(
      id: JsonSerializableUtils.instance.checkInt(json['idForApi']),
      userID: JsonSerializableUtils.instance.checkInt(json['userId']),
      date: JsonSerializableUtils.instance.checkInt(json['date']),
      approxHR: JsonSerializableUtils.instance.checkInt(json['approxHr']),
      zoneID: JsonSerializableUtils.instance.checkInt(json['ZoneID']),
      dbID: JsonSerializableUtils.instance.checkInt(json['id']),
    );
  }

  Map<String, dynamic> toJsonDB({bool unSync = false}) {
    return {
      'idForApi': id,
      'userId': userID.toString(),
      'date': date,
      'approxHr': approxHR,
      'ZoneID': zoneID,
      if (unSync) 'id': dbID,
    };
  }
}

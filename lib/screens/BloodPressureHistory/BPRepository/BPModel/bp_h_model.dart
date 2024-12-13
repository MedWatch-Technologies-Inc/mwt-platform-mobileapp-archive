import 'package:flutter/material.dart';
import 'package:health_gauge/utils/Synchronisation/string_extension.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';
import 'package:intl/intl.dart';

class BPHistoryModel {
  int id;
  int dbID;
  int userID;
  int date;
  num sys;
  num dia;

  String get getDate =>
      DateFormat(DateUtil.MMMddhhmma).format(DateTime.fromMillisecondsSinceEpoch(date));

  String get getTime => DateFormat(DateUtil.hmma).format(DateTime.fromMillisecondsSinceEpoch(date));

  final ValueNotifier<bool> showDetails = ValueNotifier(false);

  bool get isShowDetails => showDetails.value;

  set isShowDetails(bool value) {
    showDetails.value = value;
  }

  BPHistoryModel({
    required this.id,
    required this.userID,
    required this.date,
    required this.sys,
    required this.dia,
    this.dbID = 0,
  });

  factory BPHistoryModel.fromJson(Map<String, dynamic> json) {
    return BPHistoryModel(
      id: JsonSerializableUtils.instance.checkInt(json['ID']),
      userID: JsonSerializableUtils.instance.checkInt(json['userId']),
      date: JsonSerializableUtils.instance.checkInt(json['date']),
      sys: JsonSerializableUtils.instance.checkNum(json['sys']),
      dia: JsonSerializableUtils.instance.checkNum(json['dia']),
    );
  }

  DateTime get getDateTime => DateTime.fromMillisecondsSinceEpoch(date);

  double get getGraphData => ((getDateTime.hour * 60) + getDateTime.minute) / 60;

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'userId': userID,
      'date': date,
      'sys': sys,
      'dia': dia,
    };
  }

  Map<String, dynamic> toJsonDB({bool unSync = false}) {
    return {
      'idForApi': id,
      'userId': userID.toString(),
      'date': date,
      'bloodSBP': sys > dia ? sys : dia,
      'bloodDBP': sys < dia ? sys : dia,
      if (unSync) 'id': dbID,
    };
  }

  factory BPHistoryModel.fromJsonDB(Map<String, dynamic> json) {
    return BPHistoryModel(
      id: JsonSerializableUtils.instance.checkInt(json['idForApi']),
      userID: JsonSerializableUtils.instance.checkInt(json['userId']),
      date: JsonSerializableUtils.instance.checkInt(json['date']),
      sys: JsonSerializableUtils.instance.checkNum(json['bloodSBP']),
      dia: JsonSerializableUtils.instance.checkNum(json['bloodDBP']),
      dbID: JsonSerializableUtils.instance.checkInt(json['id']),
    );
  }

  factory BPHistoryModel.fromJsonSync(Map json) {
    var isTimeStamp = json['bloodStartTime'].toString().isInt;
    return BPHistoryModel(
      date: isTimeStamp
          ? JsonSerializableUtils.instance.checkInt(json['bloodStartTime'])
          : JsonSerializableUtils.instance.checkDate(json['bloodStartTime']).millisecondsSinceEpoch,
      sys: JsonSerializableUtils.instance.checkNum(json['bloodSBP']),
      dia: JsonSerializableUtils.instance.checkNum(json['bloodDBP']),
      id: 0,
      userID: 0,
    );
  }
}

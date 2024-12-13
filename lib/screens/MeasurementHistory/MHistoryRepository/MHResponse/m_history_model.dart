import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';
import 'package:intl/intl.dart';

class MHistoryModel {
  int id;
  int userID;
  String transactionID;
  MHistoryBean mHistoryBean;
  int timestamp;
  String approxSBP;
  String approxDBP;
  String date;

  String get getDate =>
      DateFormat(DateUtil.MMMddhhmma).format(DateTime.fromMillisecondsSinceEpoch(timestamp));

  DateTime get getDateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);

  double get getX => ((getDateTime.hour * 60) + getDateTime.minute) / 60;

  String get getTime =>
      DateFormat(DateUtil.hmma).format(DateTime.fromMillisecondsSinceEpoch(timestamp));

  double get getSYS => double.parse(mHistoryBean.sysDevice);

  double get getDIAS => double.parse(mHistoryBean.diasDevice);

  double get getAISys => mHistoryBean.aiSYS.toDouble() > 0
      ? mHistoryBean.aiSYS.toDouble()
      : double.parse(mHistoryBean.sysDevice);

  double get getAIDias => mHistoryBean.aiDIAS.toDouble() > 0
      ? mHistoryBean.aiDIAS.toDouble()
      : double.parse(mHistoryBean.diasDevice);

  final ValueNotifier<bool> showDetails = ValueNotifier(false);

  bool get isShowDetails => showDetails.value;

  set isShowDetails(bool value) {
    showDetails.value = value;
  }

  MHistoryModel({
    required this.id,
    required this.userID,
    required this.transactionID,
    required this.mHistoryBean,
    required this.timestamp,
    required this.approxSBP,
    required this.approxDBP,
    required this.date,
  });

  factory MHistoryModel.fromJson(Map<String, dynamic> json) {
    var tempList = (json['data'] as List).map((e) => MHistoryBean.fromJson(e)).toList();
    var date = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());
    if (tempList.first.timestamp.isNotEmpty) {
      var datetime = DateTime.fromMillisecondsSinceEpoch(int.parse(tempList.first.timestamp));
      date = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(datetime);
    }
    return MHistoryModel(
      id: JsonSerializableUtils.instance.checkInt(json['ID']),
      userID: tempList.isNotEmpty ? tempList.first.userID : 0,
      transactionID: JsonSerializableUtils.instance.checkString(json['TransactionID']),
      mHistoryBean: tempList.isNotEmpty ? tempList.first : MHistoryBean.fromJson({}),
      timestamp: tempList.isNotEmpty ? int.parse(tempList.first.timestamp) : 0,
      approxDBP: tempList.isNotEmpty ? tempList.first.diasDevice : '0',
      approxSBP: tempList.isNotEmpty ? tempList.first.sysDevice : '0',
      date: date,
    );
  }

  factory MHistoryModel.fromJsonDB(Map<String, dynamic> json) {
    // print('fromJsonDB :: ${json['data']}');
    return MHistoryModel(
      id: JsonSerializableUtils.instance.checkInt(json['ID']),
      userID: JsonSerializableUtils.instance.checkInt(json['userID']),
      transactionID: JsonSerializableUtils.instance.checkString(json['TransactionID']),
      mHistoryBean: MHistoryBean.fromJson(jsonDecode(json['data'])),
      timestamp: JsonSerializableUtils.instance.checkInt(json['timestamp']),
      approxSBP: JsonSerializableUtils.instance.checkString(json['approxSBP'], defaultValue: '0'),
      approxDBP: JsonSerializableUtils.instance.checkString(json['approxDBP'], defaultValue: '0'),
      date: JsonSerializableUtils.instance.checkString(json['date'],
          defaultValue: DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now())),
    );
  }

  Map<String, dynamic> toJson({bool isFromDB = false}) {
    return {
      'ID': id,
      'userID': userID,
      'TransactionID': transactionID,
      'data': isFromDB ? jsonEncode(mHistoryBean.toJson()) : mHistoryBean.toJson(),
      'timestamp': int.tryParse(mHistoryBean.timestamp) ?? DateTime.now().millisecondsSinceEpoch,
      'approxSBP': approxSBP,
      'approxDBP': approxDBP,
      'date': date,
    };
  }
}

class MHistoryBean {
  String timestamp;
  String diasDevice;
  String diasHG;
  String diasManual;
  String hrDevice;
  String hrManual;
  String hrvDevice;
  String sysDevice;
  String sysHG;
  String sysManual;
  num aiSYS;
  num aiDIAS;
  num bg;
  num bg1;
  int userID;
  String measurementClass;
  String deviceType;
  bool isForTraining;
  bool isForOscillometric;
  bool isFromCamera;
  bool isSavedFromOscillometric;
  bool isForHourlyHR;
  bool isForTimeBasedPpg;

  MHistoryBean({
    required this.timestamp,
    required this.diasDevice,
    required this.diasHG,
    required this.diasManual,
    required this.hrDevice,
    required this.hrManual,
    required this.hrvDevice,
    required this.sysDevice,
    required this.sysHG,
    required this.sysManual,
    required this.aiSYS,
    required this.aiDIAS,
    required this.bg,
    required this.bg1,
    required this.userID,
    required this.measurementClass,
    required this.deviceType,
    required this.isForTraining,
    required this.isForOscillometric,
    required this.isFromCamera,
    required this.isSavedFromOscillometric,
    required this.isForHourlyHR,
    required this.isForTimeBasedPpg,
  });

  factory MHistoryBean.fromJson(Map<String, dynamic> json) {
    return MHistoryBean(
      timestamp: JsonSerializableUtils.instance.checkString(json['timestamp']),
      diasDevice:
          JsonSerializableUtils.instance.checkString(json['dias_device'], defaultValue: '0'),
      diasHG: JsonSerializableUtils.instance.checkString(json['dias_healthgauge']),
      diasManual: JsonSerializableUtils.instance.checkString(json['dias_manual']),
      hrDevice: JsonSerializableUtils.instance.checkString(json['hr_device']),
      hrManual: JsonSerializableUtils.instance.checkString(json['hr_manual']),
      hrvDevice: JsonSerializableUtils.instance.checkString(json['hrv_device']),
      sysDevice: JsonSerializableUtils.instance.checkString(json['sys_device'], defaultValue: '0'),
      sysHG: JsonSerializableUtils.instance.checkString(json['sys_healthgauge']),
      sysManual: JsonSerializableUtils.instance.checkString(json['sys_manual']),
      aiSYS: JsonSerializableUtils.instance.checkNum(json['AISys']),
      aiDIAS: JsonSerializableUtils.instance.checkNum(json['AIDias']),
      bg: JsonSerializableUtils.instance.checkNum(json['BG']),
      bg1: JsonSerializableUtils.instance.checkNum(json['BG1']),
      userID: JsonSerializableUtils.instance.checkInt(json['userID']),
      measurementClass: JsonSerializableUtils.instance.checkString(json['Class']),
      deviceType: JsonSerializableUtils.instance.checkString(json['device_type']),
      isForTraining: JsonSerializableUtils.instance.checkBool(json['isForTraining']),
      isForOscillometric: JsonSerializableUtils.instance.checkBool(json['isForOscillometric']),
      isFromCamera: JsonSerializableUtils.instance.checkBool(json['IsFromCamera']),
      isSavedFromOscillometric:
          JsonSerializableUtils.instance.checkBool(json['IsSavedFromOscillometric']),
      isForHourlyHR: JsonSerializableUtils.instance.checkBool(json['isForHourlyHR']),
      isForTimeBasedPpg: JsonSerializableUtils.instance.checkBool(json['isForTimeBasedPpg']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'dias_device': diasDevice,
      'dias_healthgauge': diasHG,
      'dias_manual': diasManual,
      'hr_device': hrDevice,
      'hr_manual': hrManual,
      'hrv_device': hrvDevice,
      'sys_device': sysDevice,
      'sys_healthgauge': sysHG,
      'sys_manual': sysManual,
      'AISys': aiSYS,
      'AIDias': aiDIAS,
      'BG': bg,
      'BG1': bg1,
      'userID': userID,
      'Class': measurementClass,
      'device_type': deviceType,
      'isForTraining': isForTraining,
      'isForOscillometric': isForOscillometric,
      'IsFromCamera': isFromCamera,
      'IsSavedFromOscillometric': isSavedFromOscillometric,
      'isForHourlyHR': isForHourlyHR,
      'isForTimeBasedPpg': isForTimeBasedPpg,
    };
  }
}

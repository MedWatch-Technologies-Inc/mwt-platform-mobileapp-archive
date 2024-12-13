import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class ReminderModel {
  int? id;
  String? startTime;
  String? endTime;
  String? secondStartTime;
  String? secondEndTime;
  String? interval;
  String? label;
  String? description;
  String? imageBase64;
  bool? isNotification;
  bool? isDefault;
  bool? isEnable;
  bool? isRemove;
  bool? isSync;
  List? days = REMINDER_DAYS;

  int? reminderType;

  ReminderModel(
      {this.id,
      this.startTime,
      this.endTime,
      this.secondStartTime,
      this.secondEndTime,
      this.interval,
      this.days,
      this.label,
      this.description,
      this.imageBase64,
      this.isNotification,
      this.isDefault});

  ReminderModel.fromMap(Map map) {
    if (check("reminderType", map)) {
      reminderType = map["reminderType"];
    }
    if (check("id", map)) {
      id = map["id"];
    }
    if(check("startTime", map)){
      startTime = map["startTime"];
    }else{
      startTime = "00:00";
    }
    if(check("endTime", map)){
      endTime = map["endTime"];
    }else{
      endTime = "00:00";
    }

    if(check("secondStartTime", map)){
      secondStartTime = map["secondStartTime"];
    }else{
      secondStartTime = "00:00";
    }
    if(check("secondEndTime", map)){
      secondEndTime = map["secondEndTime"];
    }else{
      secondEndTime = "00:00";
    }
    if(check("interval", map)){
      interval = map["interval"];
    }else{
      interval = "12 ${stringLocalization.getText(StringLocalization.minute)}";
    }
    if(check("days", map)){
      days = jsonDecode(map["days"]);
    }
    if(check("label", map)){
      label = map["label"];
    }else{
      label = "";
    }

    if(check("description", map)){
      description = map["description"];
    }else{
      description = "";
    }

    if(check("imageBase64", map)){
      imageBase64 = map["imageBase64"];
    }else{
      imageBase64 = "";
    }

    if(check("isNotification", map)){
      isNotification = map["isNotification"] ==1;
    }else{
      isNotification = false;
    }
    if(check("isDefault", map)){
      isDefault = map["isDefault"] ==1;
    }else{
      isDefault = false;
    }
    if(check("isEnable", map)){
      isEnable = map["isEnable"] ==1;
    }else{
      isEnable = false;
    }
    if(check("isRemove", map)){
      isRemove = map["isRemove"] ==1;
    }else{
      isRemove = false;
    }
    if(check("isSync", map)){
      isSync = map["isSync"] ==1;
    }else{
      isSync = false;
    }
  }

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "reminderType": reminderType ?? 0,
      "startTime": startTime ?? "",
      "endTime": endTime ?? "",
      "interval": interval ?? "",
      "days": jsonEncode(days),
      "label": label ?? "",
      "description": description ?? "",
      "imageBase64": imageBase64 ?? "",
      "isDefault": (isDefault ?? false) ? 1 : 0,
      "isNotification": (isNotification ?? false) ? 1 : 0,
      "isEnable": (isEnable ?? false) ? 1 : 0,
      "isRemove": (isRemove ?? false) ? 1 : 0,
      "isSync": (isSync ?? false) ? 1 : 0,
      "secondStartTime": secondStartTime ?? "",
      "secondEndTime": secondEndTime ?? "",
    };
  }



  check(String key, Map map) {
    if(map[key] != null){
      if(map[key] is String &&  map[key] == "null"){
        return false;
      }
      return true;
    }
    return false;
  }

}


List REMINDER_DAYS =  [
  {
    "isSelected": false,
    "name":StringLocalization.sun,
    "day":Day.sunday.value
  },
  {
    "isSelected": false,
    "name":StringLocalization.mon,
    "day":Day.monday.value
  },
  {
    "isSelected": false,
    "name":StringLocalization.tue,
    "day":Day.tuesday.value
  },
  {
    "isSelected": false,
    "name":StringLocalization.wed,
    "day":Day.wednesday.value
  },
  {
    "isSelected": false,
    "name":StringLocalization.thu,
    "day":Day.thursday.value
  },
  {
    "isSelected": false,
    "name":StringLocalization.fri,
    "day":Day.friday.value
  },
  {
    "isSelected": false,
    "name":StringLocalization.sat,
    "day":Day.saturday.value
  },
];

import 'dart:convert';

import 'package:health_gauge/models/alarm_models/e80_alarm_info_model.dart';

class E80AlarmListModel {
 List<E80AlarmInfoModel>? alarmData ;
 int? alarmNum ;
 int? maxLimitNum ;
 int? optType ;


  E80AlarmListModel({this.alarmData, this.alarmNum, this.maxLimitNum , this.optType});



  E80AlarmListModel.fromMap(Map map){
    if(check("keyAlarmData", map)){
      List list = map["keyAlarmData"];
      alarmData = list.map((t)=>E80AlarmInfoModel.fromMap(t)).toList();
    }
    if(check("keyAlarmNum", map)){
      alarmNum = map["keyAlarmNum"];
    }
    if(check("keyMaxLimitNum", map)){
      maxLimitNum = map["keyMaxLimitNum"];
    }
    if(check("keyOptType", map)){
      optType = map["keyOptType"];
    }

  }

  check(String key, Map map) {
    if(map != null && map.containsKey(key) && map[key] != null){
      if(map[key] is String &&  map[key] == "null"){
        return false;
      }
      return true;
    }
    return false;
  }

}

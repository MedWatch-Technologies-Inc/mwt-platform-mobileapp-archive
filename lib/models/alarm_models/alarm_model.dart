
import 'dart:convert';

class AlarmModel {
  int? id;
  String? alarmTime;
  String? previousAlarmTime;
  List? days = [0,0,0,0,0,0,0];
  String? label;
  bool? isRepeatEnable;
  int? isAlarmEnable;

  AlarmModel({this.id, this.alarmTime, this.days , this.label,this.isRepeatEnable,this.isAlarmEnable,this.previousAlarmTime});

  AlarmModel.clone(AlarmModel mAlarmModel){
    this.id = mAlarmModel.id;
    this.alarmTime = mAlarmModel.alarmTime;
    this.days = mAlarmModel.days;
    this.label = mAlarmModel.label;
    this.isRepeatEnable = mAlarmModel.isRepeatEnable;
    this.isAlarmEnable = mAlarmModel.isAlarmEnable;
    this.previousAlarmTime = mAlarmModel.previousAlarmTime;
  }

  AlarmModel.fromMap(Map map){
    if(check("id", map)){
      id = map["id"];
    }
    if(check("alarmTime", map)){
      alarmTime = map["alarmTime"];
    }else{
      alarmTime = "00:00";
    }
    if(check("previousAlarmTime", map)){
      previousAlarmTime = map["previousAlarmTime"];
    }else{
      previousAlarmTime = "00:00";
    }

    if(check("days", map)){
      days = jsonDecode(map["days"]);
    }
    if(check("label", map)){
      label = map["label"];
    }else {
      label = "";
    }

    if(check("isRepeatEnable", map)){
      isRepeatEnable = map["isRepeatEnable"] == 1;
    }else{
      isRepeatEnable = false;
    }

    if(check("isAlarmEnable", map)){
      isAlarmEnable = map["isAlarmEnable"];
    }else{
      isAlarmEnable = 0;
    }
  }

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "alarmTime":alarmTime??"",
      "previousAlarmTime":previousAlarmTime??"",
      "days":jsonEncode(days),
      "label":label??"",
      "isRepeatEnable":(isRepeatEnable ?? false)?1:0,
      "isAlarmEnable":isAlarmEnable ?? 0,
    };
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


class E80AlarmInfoModel {
  int? alarmDelayTime ;
  int? aAlarmHour ;
  int? aAlarmMin ;
  int? alarmRepeat ;
  int? alarmType ;

  E80AlarmInfoModel({this.alarmDelayTime, this.aAlarmHour,this.aAlarmMin, this.alarmRepeat, this.alarmType});


  E80AlarmInfoModel.fromMap(Map map) {
    if (check("keyAlarmDelayTime", map)) {
      alarmDelayTime = map["keyAlarmDelayTime"];
    }
    if (check("keyAlarmHour", map)) {
      aAlarmHour = map["keyAlarmHour"];
    }
    if (check("keyAlarmMin", map)) {
      aAlarmMin = map["keyAlarmMin"];
    }
    if (check("keyAlarmRepeat", map)) {
      alarmRepeat = map["keyAlarmRepeat"];
    }
    if (check("keyAlarmType", map)) {
      alarmType = map["keyAlarmType"];
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
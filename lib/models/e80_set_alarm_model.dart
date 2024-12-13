

import 'alarm_models/e80_alarm_info_model.dart';

class E80SetAlarmModel {
  int? oldHr;
  int? oldMin;
  int? delayTime;
  int? hour;
  int? minute;
  List? days = [0, 0, 0, 0, 0, 0, 0]; //represents Monday-Sunday
  int? type;
  bool? isAlarmEnable;

  int get repeatBits {
    List temp = [isAlarmEnable ?? false ? 1 : 0];
    temp.addAll(days?.reversed??[]); //add from Sunday,Saturday... to Monday
    int intValue = 0;
    for (int i = 0; i < temp.length; ++i) {
      intValue *= 2; // double the result so far
      if (temp[i] == 1) intValue++;
    }
    return intValue;
  }

  E80SetAlarmModel(
      { this.isAlarmEnable,
       this.hour,
       this.minute,
       this.days,
       this.type,
      this.oldHr,
      this.oldMin,
      this.delayTime});

  E80SetAlarmModel.clone(E80SetAlarmModel mAlarmModel) {
    // this.id = mAlarmModel.id;
    this.hour = mAlarmModel.hour;
    this.minute = mAlarmModel.minute;
    this.days = mAlarmModel.days;
    this.type = mAlarmModel.type;
    this.delayTime = mAlarmModel.delayTime;
    this.oldHr = mAlarmModel.oldHr;
    this.oldMin = mAlarmModel.oldMin;
  }

  E80SetAlarmModel.fromModel(E80AlarmInfoModel model){
    this.oldHr= model.aAlarmHour;
    this.oldMin= model.aAlarmMin;
    this.hour= model.aAlarmHour;
    this.minute= model.aAlarmMin;
    this.type= model.alarmType;
    this.delayTime= model.alarmDelayTime;
    setRepeat(model.alarmRepeat ?? 0);
    // this.days= [1, 0, 1, 0, 0, 1, 1];
    // this.isAlarmEnable=true;
  }

  setRepeat(int repeatValue){
    var binary = repeatValue.toRadixString(2).padLeft(8,'0');
    if(repeatValue > 127){
      isAlarmEnable = true;
    }
    else{
      isAlarmEnable = false;
    }
    for(int i = 1; i < binary.length; ++i){
      if(binary[i] == '1'){
        days?[7 - i] = 1;
      }else{
        days?[7 - i] = 0;
      }
    }
    print(binary);
  }

  // E80SetAlarmModel.fromMap(Map map){
  //   if(check("id", map)){
  //     id = map["id"];
  //   }
  //   if(check("alarmTime", map)){
  //     alarmTime = map["alarmTime"];
  //   }else{
  //     alarmTime = "00:00";
  //   }
  //   if(check("previousAlarmTime", map)){
  //     previousAlarmTime = map["previousAlarmTime"];
  //   }else{
  //     previousAlarmTime = "00:00";
  //   }
  //
  //   if(check("days", map)){
  //     days = jsonDecode(map["days"]);
  //   }
  //   if(check("label", map)){
  //     label = map["label"];
  //   }else {
  //     label = "";
  //   }
  //
  //   if(check("isRepeatEnable", map)){
  //     isRepeatEnable = map["isRepeatEnable"] == 1;
  //   }else{
  //     isRepeatEnable = false;
  //   }
  //
  //   if(check("isAlarmEnable", map)){
  //     isAlarmEnable = map["isAlarmEnable"];
  //   }else{
  //     isAlarmEnable = 0;
  //   }
  // }

  // Map<String, dynamic> toMap(){
  //   return {
  //     // "id": id,
  //     // "alarmTime":alarmTime??"",
  //     // "previousAlarmTime":previousAlarmTime??"",
  //     "hour":hour,
  //     "minute":minute,
  //     "oldHr":oldHr,
  //     "oldMin":oldMin,
  //     "days":jsonEncode(days),
  //     // "label":label??"",
  //     "type":type??0,
  //     // "isRepeatEnable":isRepeatEnable?1:0,
  //     // "isAlarmEnable":isAlarmEnable ?? 0,
  //   };
  // }



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

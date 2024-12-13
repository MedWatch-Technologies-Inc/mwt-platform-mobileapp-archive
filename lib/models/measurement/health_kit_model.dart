class HealthKitModel{
  String? value;
  String? startTime;
  String? endTime;
  String? valueId;

  HealthKitModel({this.valueId,this.value,this.endTime,this.startTime});

  HealthKitModel.fromMap(Map map) {
    if (check("startTime", map)) {
      startTime = map["startTime"];
    }
    if (check("endTime", map)) {
      endTime = map["endTime"];
    }
    if(check('value', map)){
      value = map['value'];
    }
    if(check('valueId', map)){
      valueId = map['valueId'];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "startTime": startTime ?? '',
      "endTime": endTime ?? '',
      "value": value ?? '',
      "valueId":valueId ?? '',
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
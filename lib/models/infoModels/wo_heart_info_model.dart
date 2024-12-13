class WoHeartInfoModel {
  String? date;
  int? sleepMaxHeart;
  int? sleepMinHeart;
  int? sleepAvgHeart;
  int? allMaxHeart;
  int? allMinHeart;
  int? allAvgHeart;
  int? newHeart;
  List? data;

  WoHeartInfoModel.fromMap(Map map) {
    if (check("date", map)) {
      date = map["date"];
    }
    if (check("sleepMaxHeart", map)) {
      sleepMaxHeart = map["sleepMaxHeart"];
    }
    if (check("sleepMinHeart", map)) {
      sleepMinHeart = map["sleepMinHeart"];
    }
    if (check("sleepAvgHeart", map)) {
      sleepAvgHeart = map["sleepAvgHeart"];
    }
    if (check("allMaxHeart", map)) {
      allMaxHeart = map["allMaxHeart"];
    }
    if (check("allMinHeart", map)) {
      allMinHeart = map["allMinHeart"];
    }
    if (check("allAvgHeart", map)) {
      allAvgHeart = map["allAvgHeart"];
    }
    if (check("newHeart", map)) {
      newHeart = map["newHeart"];
    }
    if (check("data", map)) {
      data = map["data"];
    }
  }

  @override
  String toString() {
    return 'WoHeartInfoModel{date: $date, sleepMaxHeart: $sleepMaxHeart, sleepMinHeart: $sleepMinHeart, sleepAvgHeart: $sleepAvgHeart, allMaxHeart: $allMaxHeart, allMinHeart: $allMinHeart, allAvgHeart: $allAvgHeart, newHeart: $newHeart, data: $data}';
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

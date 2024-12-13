class PpgInfoReadingModel {
  double? point;
  Object? startTime;
  Object? endTime;

  List? pointList;

  PpgInfoReadingModel();

  PpgInfoReadingModel.fromMap(Map map) {
    if (check("endTime", map)) {
      endTime = map["endTime"];
    }
    if (check("startTime", map)) {
      startTime = map["startTime"];
    }
    if (check("point", map)) {
      point = double.parse((map["point"]).toString());
    }
    if (check("pointList", map)) {
      pointList = map["pointList"];
    }
    if (map["startTimeWithMilliseconds"] is String) {
      startTime = DateTime.parse(map["startTimeWithMilliseconds"]).toUtc().millisecondsSinceEpoch;
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

  @override
  String toString() {
    return 'PpgInfoModel {point: $point}';
  }
}

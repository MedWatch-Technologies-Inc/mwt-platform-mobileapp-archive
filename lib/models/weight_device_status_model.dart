class WeightDeviceStatusModel {
  int? status;

  WeightDeviceStatusModel(this.status);

  WeightDeviceStatusModel.fromMap(Map map) {
    if (check("status", map)) {
      status = map["status"];
    }
  }

    check(String key, Map map) {
        if ( map[key] != null) {
          if (map[key] is String && map[key] == "null") {
            return false;
          }
          return true;
        }
        return false;
  }
}
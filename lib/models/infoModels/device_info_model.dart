class DeviceInfoModel {
  int? power;
  int? type;
  String? deviceNumber;
  String? deviceName;

  DeviceInfoModel.fromMap(Map map) {
    if (check("power", map)) {
      power = map["power"];
    }
    if (check("type", map)) {
      type = map["type"];
    }
    if (check("device_number", map)) {
      deviceNumber = map["device_number"].toString();
    }
    if (check("device_name", map)) {
      deviceName = map["device_name"].toString();
    }
  }

  check(String key, Map map) {
    if (map[key] != null) {
      if (map[key] is String && map[key] == "null") {
        return false;
      }
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'DeviceInfoModel{power: $power, type: $type, device_number: $deviceNumber, device_name: $deviceName}';
  }
}

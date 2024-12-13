import 'package:health_gauge/utils/database_table_name_and_fields.dart';

class BLEDeviceModel {
  String? deviceName;
  String? deviceAddress;
  String? deviceRange;
  String? deviceUuids;
  String? deviceBondState;

  BLEDeviceModel(
      {this.deviceName,
        this.deviceAddress,
        this.deviceRange,
        this.deviceUuids,
        this.deviceBondState
      });

  BLEDeviceModel.fromMap(Map map) {
    if (check("name", map)) {
      deviceName = map["name"].toString();
    }
    if (check("rssi", map)) {
      deviceRange = map["rssi"].toString();
    }
    if (check("address", map)) {
      deviceAddress = map["address"].toString();
    }
    if (check("Uuids", map)) {
      deviceUuids = map["Uuids"].toString();
    }
    if (check("BondState", map)) {
      deviceBondState = map['BondState'].toString();
    }

  }

  BLEDeviceModel.clone(BLEDeviceModel device) {
    deviceName = device.deviceName;
    deviceAddress = device.deviceAddress;
    deviceRange = device.deviceRange;
    deviceUuids = device.deviceUuids ?? '';
    deviceBondState = device.deviceBondState ?? '0';

  }



  Map toMap() {
    return {
      "name": deviceName,
      "rssi": deviceRange,
      "address": deviceAddress,
      "Uuids": deviceUuids,
      "BondState": deviceBondState,

    };
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
}

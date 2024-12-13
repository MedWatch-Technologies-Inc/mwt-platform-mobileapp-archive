import 'package:health_gauge/utils/database_table_name_and_fields.dart';

class DeviceModel {
  String? deviceName;
  String? deviceAddress;
  String? deviceRange;
  bool isWeightScaleDevice = false;

  int? sdkType;

  int? id;
  int? idForApi;
  int? isBlocked;
  int? isSync;
  int? isRemoved;
  String? date;
  String? friendlyName;

  DeviceModel(
      {this.deviceName,
      this.deviceAddress,
      this.deviceRange,
      this.id,
      this.idForApi,
      this.isBlocked,
      this.isSync,
      this.isRemoved,
      this.date,
      this.friendlyName});

  DeviceModel.fromMap(Map map) {
    if (check("name", map)) {
      deviceName = map["name"].toString();
    }
    if (check("rssi", map)) {
      deviceRange = map["rssi"].toString();
    }
    if (check("address", map)) {
      deviceAddress = map["address"].toString();
    }
    if (check("isWeightScaleDevice", map)) {
      isWeightScaleDevice = map["isWeightScaleDevice"];
    }
    try {
      if (check("sdkType", map)) {
        sdkType = map["sdkType"];
      }
    } catch (e) {
      print(e);
    }
  }

  DeviceModel.clone(DeviceModel device) {
    this.deviceName = device.deviceName;
    this.deviceAddress = device.deviceAddress;
    this.deviceRange = device.deviceRange;
    this.id = device.id;
    this.idForApi = device.idForApi ?? 0;
    this.isBlocked = device.isBlocked ?? 0;
    this.isSync = device.isSync ?? 0;
    this.isRemoved = device.isRemoved ?? 0;
    this.isWeightScaleDevice = device.isWeightScaleDevice;
    this.date = device.date ?? (DateTime.now().toString());
    this.sdkType = device.sdkType ?? 0;
  }

  Map toMap() {
    return {
      "name": deviceName,
      "rssi": deviceRange,
      "address": deviceAddress,
      "isWeightScaleDevice": isWeightScaleDevice,
      "sdkType": sdkType ?? 0,
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

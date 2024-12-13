import 'dart:convert';

import 'package:health_gauge/utils/json_serializable_utils.dart';

class DeviceSettingModel {
  int id;
  int UserID;
  String wearingMethod;
  HRMonitoringBean hrMonitoring;
  BPMonitoringBean bpMonitoring;
  bool liftWristBright;
  bool doNotDisturb;
  String brightness;
  TemperatureMonitoringBean temperatureMonitoring;
  OxygenMonitoringBean oxygenMonitoring;

  bool get isWearLeft => wearingMethod.toLowerCase() == 'left';

  DeviceSettingModel({
    required this.id,
    required this.UserID,
    required this.wearingMethod,
    required this.hrMonitoring,
    required this.bpMonitoring,
    required this.liftWristBright,
    required this.doNotDisturb,
    required this.brightness,
    required this.temperatureMonitoring,
    required this.oxygenMonitoring,
  });

  factory DeviceSettingModel.fromJson(Map<String, dynamic> json) {
    return DeviceSettingModel(
      id: JsonSerializableUtils.instance.checkInt(json['id']),
      UserID: JsonSerializableUtils.instance.checkInt(json['UserID']),
      wearingMethod: JsonSerializableUtils.instance.checkString(json['wearing_method']),
      hrMonitoring: HRMonitoringBean.fromJson(json['hr_monitoring'] ?? {}),
      bpMonitoring: BPMonitoringBean.fromJson(json['bp_monitoring'] ?? {}),
      liftWristBright: JsonSerializableUtils.instance.checkBool(json['lift_wrist_bright']),
      doNotDisturb: JsonSerializableUtils.instance.checkBool(json['do_not_disturb']),
      brightness: JsonSerializableUtils.instance.checkString(json['brightness']),
      temperatureMonitoring:
          TemperatureMonitoringBean.fromJson(json['temperature_monitoring'] ?? {}),
      oxygenMonitoring: OxygenMonitoringBean.fromJson(json['oxygen_monitoring'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'UserID': UserID,
      'wearingMethod': wearingMethod,
      'hrMonitoring': jsonEncode(hrMonitoring.toJson()),
      'bpMonitoring': jsonEncode(bpMonitoring.toJson()),
      'liftWristBright': liftWristBright,
      'doNotDisturb': doNotDisturb,
      'brightness': brightness,
      'temperatureMonitoring': jsonEncode(temperatureMonitoring.toJson()),
      'oxygenMonitoring': jsonEncode(oxygenMonitoring.toJson()),
    };
  }
}

class OxygenMonitoringBean {
  bool status;
  num timeInterval;

  OxygenMonitoringBean({
    required this.status,
    required this.timeInterval,
  });

  factory OxygenMonitoringBean.fromJson(Map<String, dynamic> json) {
    return OxygenMonitoringBean(
      status: JsonSerializableUtils.instance.checkBool(json['status'], defaultValue: true),
      timeInterval: JsonSerializableUtils.instance.checkNum(json['time_interval'], defaultValue: 5),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'time_interval': timeInterval,
    };
  }
}

class TemperatureMonitoringBean {
  bool status;
  num timeInterval;

  TemperatureMonitoringBean({
    required this.status,
    required this.timeInterval,
  });

  factory TemperatureMonitoringBean.fromJson(Map<String, dynamic> json) {
    return TemperatureMonitoringBean(
      status: JsonSerializableUtils.instance.checkBool(json['status'], defaultValue: true),
      timeInterval: JsonSerializableUtils.instance.checkNum(json['time_interval'], defaultValue: 5),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'time_interval': timeInterval,
    };
  }
}

class BPMonitoringBean {
  bool status;
  num timeInterval;

  BPMonitoringBean({
    required this.status,
    required this.timeInterval,
  });

  factory BPMonitoringBean.fromJson(Map<String, dynamic> json) {
    return BPMonitoringBean(
      status: JsonSerializableUtils.instance.checkBool(json['status'], defaultValue: true),
      // timeInterval: JsonSerializableUtils.instance.checkNum(json['time_interval'], defaultValue: 5),
      timeInterval: 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'time_interval': timeInterval,
    };
  }
}

class HRMonitoringBean {
  bool status;
  num timeInterval;

  HRMonitoringBean({
    required this.status,
    required this.timeInterval,
  });

  factory HRMonitoringBean.fromJson(Map<String, dynamic> json) {
    return HRMonitoringBean(
      status: JsonSerializableUtils.instance.checkBool(json['status'], defaultValue: true),
      // timeInterval: JsonSerializableUtils.instance.checkNum(json['time_interval'], defaultValue: 5),
      timeInterval: 5 ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'time_interval': timeInterval,
    };
  }
}

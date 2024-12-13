import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:health_gauge/screens/device_management/api_client/device_setting_repo.dart';
import 'package:health_gauge/screens/device_management/api_client/device_setting_updatData.dart';
import 'package:health_gauge/screens/device_management/model/device_setting_model.dart';
import 'package:health_gauge/screens/device_management/model/m_t_response.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DeviceManagementHelper {
  static final DeviceManagementHelper _singleton = DeviceManagementHelper._internal();

  factory DeviceManagementHelper() {
    return _singleton;
  }

  DeviceManagementHelper._internal();

  final ValueNotifier<DeviceSettingModel?> _deviceSetting = ValueNotifier(null);

  DeviceSettingModel? get deviceSetting => _deviceSetting.value;

  ValueNotifier<DeviceSettingModel?> get deviceSettingNotifier => _deviceSetting;

  set deviceSetting(DeviceSettingModel? value) {
    _deviceSetting.value = value;
    _deviceSetting.notifyListeners();
  }

  int get getUserID => int.parse(preferences?.getString(Constants.prefUserIdKeyInt) ?? '0');

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<void> updateDeviceSetting() async {
    if (deviceSetting != null) {
      var params = UpdateDataRequest(
        ID: deviceSetting!.id,
        FKUserID: deviceSetting!.UserID,
        wearing_method: deviceSetting!.wearingMethod,
        hr_monitoring_status: deviceSetting!.hrMonitoring.status,
        hr_monitoring_time_interval: deviceSetting!.hrMonitoring.timeInterval,
        bp_monitoring_status: deviceSetting!.bpMonitoring.status,
        bp_monitoring_time_interval: deviceSetting!.bpMonitoring.timeInterval,
        lift_wrist_bright: deviceSetting!.liftWristBright,
        do_not_disturb: deviceSetting!.doNotDisturb,
        brightness: deviceSetting!.brightness,
        temperature_monitoring_status: deviceSetting!.temperatureMonitoring.status,
        temperature_monitoring_time_interval: deviceSetting!.temperatureMonitoring.timeInterval,
        oxygen_monitoring_status: deviceSetting!.oxygenMonitoring.status,
        oxygen_monitoring_time_interval: deviceSetting!.oxygenMonitoring.timeInterval,
      );
      var deviceSettingResult = await DeviceSettingRepo().postDeviceSettings(getUserID, params);
    }
  }

  Future<void> fetchDeviceSettings({bool isInIt = false}) async {
    try {
      if (isInIt) {
        refreshController.requestRefresh();
        return;
      }
      var deviceSettingResult = await DeviceSettingRepo().fetchDeviceSettings(getUserID);
      if (deviceSettingResult.getData != null && deviceSettingResult.hasData) {
        var deviceSettingModel = deviceSettingResult.getData!.data;
        if (deviceSettingModel != null) {
          var result = checkIfUpdated(deviceSettingModel);
          if (result) {
            deviceSetting = deviceSettingModel;
          }
        }
      }
    } catch (e) {
      log('MethodException :: fetchDeviceSettings :: $e');
    } finally {
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      }
    }
  }

  bool checkIfUpdated(DeviceSettingModel deviceSettingModel) {
    return deviceSettingModel.toJson() != (deviceSetting?.toJson() ?? {});
  }

  Map<String, dynamic> staticJson = {
    'wearing_method': 'right',
    'hr_monitoring': {'status': true, 'time_interval': 5},
    'bp_monitoring': {'status': true, 'time_interval': 5},
    'lift_wrist_bright': true,
    'do_not_disturb': false,
    'brightness': 'medium',
    'temperature_monitoring': {'status': true, 'time_interval': 5},
    'oxygen_monitoring': {'status': true, 'time_interval': 5}
  };
}

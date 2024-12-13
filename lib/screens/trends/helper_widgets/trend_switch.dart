import 'package:flutter/material.dart';
import 'package:health_gauge/screens/device_management/device_management_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/custom_switch.dart';

enum TrendType { hr, bp, spo2 }

class TrendSwitch extends StatelessWidget {
  TrendSwitch({
    required this.value,
    required this.trendType,
    super.key,
  });

  final bool value;
  final TrendType trendType;

  final DeviceManagementHelper _helper = DeviceManagementHelper();

  @override
  Widget build(BuildContext context) {
    return CustomSwitch(
      value: value,
      onChanged: (value) {
        onChanged(context: context,value: value);
      },
      activeColor: HexColor.fromHex('#00AFAA'),
      inactiveTrackColor: Theme
          .of(context)
          .brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : HexColor.fromHex('#E7EBF2'),
      inactiveThumbColor: Theme
          .of(context)
          .brightness == Brightness.dark
          ? Colors.white.withOpacity(0.6)
          : HexColor.fromHex('#D1D9E6'),
      activeTrackColor: Theme
          .of(context)
          .brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : HexColor.fromHex('#E7EBF2'),
    );
  }

  void onChanged({required BuildContext context, required bool value}) {
    switch (trendType) {
      case TrendType.hr:
        onHRChange(context,value: value);
        break;
      case TrendType.bp:
      // TODO: Handle this case.
        break;
      case TrendType.spo2:
        onSPO2Change(context,value: value);
        break;
    }
  }

  void onHRChange(BuildContext context, {bool value = false}) {
    _helper.deviceSetting?.hrMonitoring.status = value;
    _helper.deviceSetting?.hrMonitoring.timeInterval = 5;
    try {
      preferences?.setInt(Constants.heartRateInterval,
          _helper.deviceSetting?.hrMonitoring.timeInterval.toInt() ?? 5);
      connections.setHourlyHrMonitorOn(
        _helper.deviceSetting?.hrMonitoring.status ?? true,
        _helper.deviceSetting?.hrMonitoring.timeInterval.toInt() ?? 5,
        context: context,
        showLoader: true,
      );
    } catch (e) {
      print('Exception at setMonitorInDevice $e');
    }
    _helper.deviceSettingNotifier.notifyListeners();
    preferences?.setBool(Constants.isHourlyHrMonitorOnKey, value);
  }

  void onSPO2Change(BuildContext context, {bool value = false}) {
    _helper.deviceSetting?.oxygenMonitoring.status = value;
    _helper.deviceSetting?.oxygenMonitoring.timeInterval = 5;
    try {
      preferences?.setInt(Constants.oxygenTimeInterval,
          _helper.deviceSetting?.oxygenMonitoring.timeInterval.toInt() ?? 5);
      connections.setOxygenMonitorOn(
        _helper.deviceSetting?.oxygenMonitoring.status ?? true,
        _helper.deviceSetting?.oxygenMonitoring.timeInterval.toInt() ?? 5,
        context: context,
        showLoader: true,
      );
    } catch (e) {
      print('Exception at setMonitorInDevice $e');
    }
    _helper.deviceSettingNotifier.notifyListeners();
    preferences?.setBool(Constants.isOxygenMonitorOnKey, value);
  }
}

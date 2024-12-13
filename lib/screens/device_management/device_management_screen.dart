import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/bp_monitoring_screen.dart';
import 'package:health_gauge/screens/device_management/device_management_helper.dart';
import 'package:health_gauge/screens/device_management/model/device_setting_model.dart';
import 'package:health_gauge/screens/device_management/picker_operationals_buttons.dart';
import 'package:health_gauge/screens/heart_rate_monitoring_screen.dart';
import 'package:health_gauge/screens/loading_screen.dart';
import 'package:health_gauge/screens/reminders/app_reminders_screen.dart';
import 'package:health_gauge/screens/scheduled_monitors/oxygen_monitoring_screen.dart';
import 'package:health_gauge/screens/scheduled_monitors/temperature_monitoring_screen.dart';
import 'package:health_gauge/screens/trends/helper_widgets/trend_switch.dart';
import 'package:health_gauge/screens/trends/helper_widgets/trend_tile.dart';
import 'package:health_gauge/screens/trends/trend_monitor_screen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/buttons.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_picker.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../reminders_screen.dart';

class DeviceManagementScreen extends StatefulWidget {
  @override
  _DeviceManagementScreenState createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  bool isHourlyHrMonitorOn = false;
  bool isBPMonitorOn = false;
  bool timeFormat24h = true;

  String firmwareVersion = 'unknown';

  List<String> brightnessList = [
    StringLocalization.Low,
    StringLocalization.Medium,
    StringLocalization.High,
  ];

  late FixedExtentScrollController brightnessController;
  DeviceModel? connectedDevice;

  final DeviceManagementHelper _helper = DeviceManagementHelper();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await _helper.fetchDeviceSettings(isInIt: true);
    });
    brightnessController = FixedExtentScrollController(
      initialItem: 0,
    );
    getPreference();
    super.initState();
    screen = Constants.deviceManagement;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              leading: IconButton(
                key: Key('deviceSettingsBackButton'),
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(
                        'asset/dark_leftArrow.png',
                        width: 13,
                        height: 22,
                      )
                    : Image.asset(
                        'asset/leftArrow.png',
                        width: 13,
                        height: 22,
                      ),
              ),
              title: Text(
                StringLocalization.of(context).getText(StringLocalization.deviceManagement),
                style: TextStyle(
                    color: HexColor.fromHex('62CBC9'), fontSize: 18, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: layoutMain(),
      ),
    );
  }

  Widget layoutMain() {
    return Container(
      padding: EdgeInsets.only(top: 20.0.h, right: 20.0.w, left: 20.0.w, bottom: 20.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 10.h),
          Image.asset(
            AppImages().appLogo,
            height: 140.h,
          ),
          SizedBox(height: 25.h),
          Expanded(
            child: SmartRefresher(
              controller: _helper.refreshController,
              onRefresh: _helper.fetchDeviceSettings,
              physics: BouncingScrollPhysics(),
              child: ValueListenableBuilder(
                valueListenable: _helper.deviceSettingNotifier,
                builder: (BuildContext context, DeviceSettingModel? value, Widget? child) {
                  if (value == null) {
                    return SizedBox(
                      height: 200.h,
                      child: Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        wearType(),
                        hourlyMonitor(),
                        // trendsMonitor(),
                        // oxygenMonitoring(),
                        liftWrist(),
                        setBrightness(),
                        Visibility(
                          visible: connectedDevice?.sdkType == Constants.e66,
                          child: ListTile(
                            onTap: resetConfirmationDialog,
                            title: Text(StringLocalization.of(context)
                                .getText(StringLocalization.resetWatch)),
                          ),
                        ),
                        Visibility(
                          visible: connectedDevice?.sdkType == Constants.e66,
                          child: ListTile(
                            key: Key('clickOnShutDownButton'),
                            onTap: shutdownConfirmationDialog,
                            title: Text(StringLocalization.of(context)
                                .getText(StringLocalization.shutDownWatch)),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future resetConfirmationDialog() async {
    var dialog = CustomDialog(
      title: 'Smartwatch Factory Reset',
      subTitle:
          'Are you sure you want to factory reset your smartwatch? This action will restore the device to its original factory settings, erasing all data and personalization. Press \'Confirm\' to proceed or \'Cancel\' to return to the device settings page.',
      onClickNo: () async {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      onClickYes: () async {
        onTapReset();
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      maxLine: 10,
    );

    return showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );
  }

  Future shutdownConfirmationDialog() async {
    var dialog = CustomDialog(
      title: 'Smartwatch Shutdown',
      subTitle:
          'Are you sure you want to shut down your smart watch? This action will power off the device, and you will need to restart it to use again. Press \'Confirm\' to proceed or \'Cancel\' to return to the device settings page.',
      onClickNo: () async {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      onClickYes: () async {
        onTapShutDown();
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      maxLine: 10,
    );

    return showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );
  }

  Widget trendsMonitor() {
    return ListTile(
      key: Key('clickOnArrowIconTrends'),
      onTap: () {
        Constants.navigatePush(TrendMonitorScreen(), context);
      },
      title: Text(StringLocalization.of(context).getText(StringLocalization.trends)),
      trailing: Icon(Icons.navigate_next),
    );
  }

  Widget hourlyMonitor() {
    return ValueListenableBuilder(
      valueListenable: _helper.deviceSettingNotifier,
      builder: (BuildContext context, DeviceSettingModel? value, Widget? child) {
        return TrendTile(
          title: StringLocalization.hrBPMonitoring,
          selectedValue: _helper.deviceSettingNotifier.value?.hrMonitoring.status ?? true,
          trendType: TrendType.hr,
        );
      },
    );
  }

  Widget oxygenMonitoring() {
    return ListTile(
      onTap: () {
        Constants.navigatePush(OxygenMonitoringScreen(), context);
      },
      title: Text(StringLocalization.of(context).getText(StringLocalization.oxygenMonitoring)),
      trailing: Icon(Icons.navigate_next),
    );
  }

  Widget bpMonitor() {
    return ListTile(
      key: Key('clickOnArrowIconBPMonitoring'),
      onTap: () {
        Constants.navigatePush(BPMonitoringScreen(), context);
      },
      title: Text(StringLocalization.of(context).getText(StringLocalization.bpMonitoring)),
      trailing: Icon(Icons.navigate_next),
    );
  }

  Widget liftWrist() {
    return ListTile(
      title: Text(StringLocalization.of(context).getText(StringLocalization.liftTheWristBrighten)),
      trailing: ValueListenableBuilder(
          valueListenable: _helper.deviceSettingNotifier,
          builder: (context, value, widget) {
            return CustomSwitch(
              value: value?.liftWristBright ?? true,
              onChanged: (value) {
                _helper.deviceSetting?.liftWristBright = value;
                _helper.deviceSettingNotifier.notifyListeners();
                connections
                    .setLiftTheWristBrightnessOn(_helper.deviceSetting?.liftWristBright ?? true);
                preferences?.setBool(Constants.isLiftTheWristBrightnessOnKey, value);
              },
              activeColor: HexColor.fromHex('#00AFAA'),
              inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : HexColor.fromHex('#E7EBF2'),
              inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.6)
                  : HexColor.fromHex('#D1D9E6'),
              activeTrackColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : HexColor.fromHex('#E7EBF2'),
            );
          }),
    );
  }

  Widget doNotDisturb() {
    return ListTile(
      title: Text(StringLocalization.of(context).getText(StringLocalization.doNotDisturb)),
      trailing: ValueListenableBuilder(
          valueListenable: _helper.deviceSettingNotifier,
          builder: (context, value, widget) {
            return CustomSwitch(
              value: value?.doNotDisturb ?? false,
              onChanged: (value) {
                _helper.deviceSetting?.doNotDisturb = value;
                _helper.deviceSettingNotifier.notifyListeners();
                connections.setDoNotDisturb(_helper.deviceSetting?.doNotDisturb ?? false);
                preferences?.setBool(Constants.isDoNotDisturbKey, value);
              },
              activeColor: HexColor.fromHex('#00AFAA'),
              inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : HexColor.fromHex('#E7EBF2'),
              inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.6)
                  : HexColor.fromHex('#D1D9E6'),
              activeTrackColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : HexColor.fromHex('#E7EBF2'),
            );
          }),
    );
  }

  Widget timeFormat() {
    return ListTile(
      title: Text(StringLocalization.of(context).getText(StringLocalization.timeFormat)),
      trailing: ToggleSwitch(
        totalSwitches: 2,
        initialLabelIndex: timeFormat24h ? 1 : 0,
        activeBgColor: [AppColor.primaryColor],
        // activeTextColor: Colors.white,
        inactiveBgColor:
            Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.grey[200],
        // inactiveTextColor: AppColor.black,
        labels: [
          StringLocalization.of(context).getText(StringLocalization.twelve),
          StringLocalization.of(context).getText(StringLocalization.twentyFour)
        ],
        onToggle: (index) {
          switch (index) {
            case 0:
              timeFormat24h = false;
              //              if(Platform.isAndroid) {
              connections.setTimeFormat(false);
              //              }else{
//                sendDataToSDK();
//              }
              preferences?.setBool(Constants.isTimeFormat24hKey, false);
              setState(() {});
              break;
            case 1:
              timeFormat24h = true;
              //              if(Platform.isAndroid) {
              connections.setTimeFormat(true);
              //              }else{
//                sendDataToSDK();
//              }
              preferences?.setBool(Constants.isTimeFormat24hKey, true);
              setState(() {});
              break;
          }
        },
      ),
    );
  }

  Widget wearType() {
    return ListTile(
      title: Text(StringLocalization.of(context).getText(StringLocalization.wearType)),
      trailing: ValueListenableBuilder(
          valueListenable: _helper.deviceSettingNotifier,
          builder: (context, updateValue, widget) {
            return ToggleSwitch(
              totalSwitches: 2,
              initialLabelIndex: updateValue!.isWearLeft ? 0 : 1,
              activeBgColor: [AppColor.primaryColor],
              // activeTextColor: Colors.white,
              inactiveBgColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black54
                  : Colors.grey[200],
              // inactiveTextColor: AppColor.black,
              labels: [
                StringLocalization.of(context).getText(StringLocalization.leftHand),
                StringLocalization.of(context).getText(StringLocalization.rightHand)
              ],
              onToggle: (index) {
                switch (index) {
                  case 0:
                    connections.setWearType(true);
                    preferences?.setBool(Constants.isWearOnLeftKey, true);
                    _helper.deviceSetting!.wearingMethod = 'left';
                    break;
                  case 1:
                    connections.setWearType(false);
                    preferences?.setBool(Constants.isWearOnLeftKey, false);
                    _helper.deviceSetting!.wearingMethod = 'right';
                    break;
                }
                _helper.deviceSettingNotifier.notifyListeners();
              },
            );
          }),
    );
  }

  Widget firmwareUpgrade() {
    return ListTile(
      onTap: () {},
      title: Text(StringLocalization.of(context).getText(StringLocalization.firmUpdate)),
      trailing: TitleText(text: firmwareVersion),
    );
  }

  Widget appReminders() {
    return ListTile(
      onTap: () {
        Constants.navigatePush(AppRemindersScreen(), context);
      },
      title: Text(StringLocalization.of(context).getText(StringLocalization.appReminders)),
      trailing: Icon(Icons.navigate_next),
    );
  }

  Widget reminders() {
    return ListTile(
      onTap: () {
        Constants.navigatePush(RemindersScreen(), context);
      },
      title: Text(StringLocalization.of(context).getText(StringLocalization.reminders)),
      trailing: Icon(Icons.navigate_next),
    );
  }

  Widget setBrightness() {
    if (connectedDevice?.sdkType == 2) {
      //sdk type 2 is for e66 sdk
      return ValueListenableBuilder(
          valueListenable: _helper.deviceSettingNotifier,
          builder: (context, value, widget) {
            return ListTile(
              onTap: () {
                var selectedIndex = brightnessList.indexWhere(
                    (element) => element.toLowerCase() == value?.brightness.toLowerCase());
                if (selectedIndex >= 0) {
                  brightnessController = FixedExtentScrollController(
                    initialItem: selectedIndex,
                  );
                }
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Theme.of(context).cardColor,
                  useRootNavigator: true,
                  isDismissible: false,
                  enableDrag: true,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: RoundedRectangleBorder(),
                  builder: (context) {
                    return brightnessPicker();
                  },
                );
              },
              title: Text(StringLocalization.of(context).getText(StringLocalization.brightness)),
              trailing: Icon(Icons.navigate_next),
            );
          });
    }
    return Container();
  }

  Widget temperatureMonitoring() {
    if (connectedDevice?.sdkType == 2) {
      return ListTile(
        key: Key('clickOnArrowIconTempMonitoring'),
        onTap: () {
          Constants.navigatePush(TemperatureMonitoringScreen(), context);
        },
        title:
            Text(StringLocalization.of(context).getText(StringLocalization.temperatureMonitoring)),
        trailing: Icon(Icons.navigate_next),
      );
    }
    return Container();
  }

  Widget brightnessPicker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PickerOperationalButtons(
          positiveCallback: () {
            try {
              var brightness = brightnessList.elementAt(brightnessController.selectedItem);
              _helper.deviceSetting?.brightness = brightness;
              var index = brightnessList
                  .indexWhere((element) => element.toLowerCase() == brightness.toLowerCase());
              connections.setBrightness(index >= 0 ? index : 1);
              preferences?.setString(
                  Constants.brightnessLevel, _helper.deviceSetting?.brightness ?? 'Medium');
              if (mounted) {
                Navigator.of(context, rootNavigator: true).pop();
              }
            } catch (e) {
              print('Exception at on pressed $e');
            }
          },
        ),
        SizedBox(
          height: 100.h,
          child: CustomCupertinoPicker(
            scrollController: brightnessController,
            backgroundColor: Theme.of(context).cardColor,
            children: List.generate(
              brightnessList.length,
              (index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(5.0.w, 5.0.h, 5.0.w, 5.0.h),
                  child: TitleText(
                    text: stringLocalization.getText(brightnessList[index]),
                  ),
                );
              },
            ),
            diameterRatio: 20,
            itemExtent: 40,
            useMagnifier: true,
            magnification: 1.0,
            looping: false,
            onSelectedItemChanged: (int index) {
              // selectedBrightness = brightnessList[index];
              // connections.setBrightness(index);
              // setState(() {});
            },
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  void onTapReset() {
    connections.resetBracelet();
  }

  void onTapShutDown() {
    connections.shutdownBracelet();
  }

  Future getPreference() async {
    connections.checkAndConnectDeviceIfNotConnected().then((value) {
      connectedDevice = value;
      if (mounted) {
        setState(() {});
      }
    });
    timeFormat24h = preferences?.getBool(Constants.isTimeFormat24hKey) ?? true;
    isHourlyHrMonitorOn = preferences?.getBool(Constants.isHourlyHrMonitorOnKey) ?? true;
    isBPMonitorOn = preferences?.getBool(Constants.isBPMonitorOnKey) ?? true;
  }
}

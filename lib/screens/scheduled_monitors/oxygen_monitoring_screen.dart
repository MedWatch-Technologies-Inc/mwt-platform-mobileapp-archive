import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/screens/device_management/device_management_helper.dart';

//import 'package:flutter_screenutil/screenutil.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/buttons.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:health_gauge/widgets/custom_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OxygenMonitoringScreen extends StatefulWidget {
  @override
  _OxygenMonitoringScreenState createState() => _OxygenMonitoringScreenState();
}

class _OxygenMonitoringScreenState extends State<OxygenMonitoringScreen> {
  List timeIntervalList = List<int>.generate(Constants.maximumSecondsValue, (index) => index + 1);
  late FixedExtentScrollController timeIntervalController;

  final DeviceManagementHelper _helper = DeviceManagementHelper();

  @override
  void initState() {
    timeIntervalController = FixedExtentScrollController(
      initialItem: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ],
          ),
          child: AppBar(
            elevation: 0,
            leading: IconButton(
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
            centerTitle: true,
            title: Text(
              StringLocalization.of(context).getText(StringLocalization.oxygenMonitoring),
              style: TextStyle(
                  color: HexColor.fromHex('#62CBC9'), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(
            shrinkWrap: true,
            children: [
              oxygenMonitorSwitch(),
              setTimeInterval(),
            ],
          ),
        ),
      ),
    );
  }

  Widget oxygenMonitorSwitch() {
    return ListTile(
      title: Text(StringLocalization.of(context).getText(StringLocalization.oxygenMonitoring)),
      trailing: ValueListenableBuilder(
          valueListenable: _helper.deviceSettingNotifier,
          builder: (context, value, widget) {
            return CustomSwitch(
              value: value?.oxygenMonitoring.status ?? true,
              onChanged: (value) {
                _helper.deviceSetting?.oxygenMonitoring.status = value;
                _helper.deviceSetting?.oxygenMonitoring.timeInterval = 5;
                _helper.deviceSettingNotifier.notifyListeners();
                setMonitorInDevice();
                preferences?.setBool(Constants.isOxygenMonitorOnKey, value);
                setState(() {});
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

  Widget setTimeInterval() {
    return ListTile(
      onTap: () {
        // int selectedIndex = timeIntervalList
        //     .indexOf(_helper.deviceSetting?.oxygenMonitoring.timeInterval.toInt() ?? 5);
        // if (selectedIndex > -1) {
        //   timeIntervalController = FixedExtentScrollController(
        //     initialItem: selectedIndex,
        //   );
        // }
        // showModalBottomSheet(
        //   context: context,
        //   backgroundColor: Theme.of(context).cardColor,
        //   useRootNavigator: true,
        //   isDismissible: false,
        //   builder: (context) {
        //     return timeIntervalPicker();
        //   },
        // );
      },
      title: Text('Time Interval'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('${_helper.deviceSetting?.oxygenMonitoring.timeInterval ?? 5} min'),
          Icon(Icons.navigate_next),
        ],
      ),
    );
  }

  Widget timeIntervalPicker() {
    return Container(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatBtn(
                  onPressed: () {
                    try {
                      _helper.deviceSetting?.oxygenMonitoring.timeInterval =
                          timeIntervalList.elementAt(timeIntervalController.selectedItem);
                      connections.setOxygenMonitorOn(
                          _helper.deviceSetting?.oxygenMonitoring.status ?? true,
                          _helper.deviceSetting?.oxygenMonitoring.timeInterval.toInt() ?? 5);
                      preferences?.setInt(Constants.oxygenTimeInterval,
                          _helper.deviceSetting?.oxygenMonitoring.timeInterval.toInt() ?? 5);
                      if (mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                        setState(() {});
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  text: stringLocalization.getText(StringLocalization.confirm).toUpperCase()),
              FlatBtn(
                  onPressed: () {
                    if (this.mounted) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                  text: stringLocalization.getText(StringLocalization.cancel).toUpperCase()),
            ],
          )),
          Flexible(
            child: CustomCupertinoPicker(
              scrollController: timeIntervalController,
              backgroundColor: Theme.of(context).cardColor,
              children: List.generate(timeIntervalList.length, (index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  child: TitleText(
                    text: timeIntervalList[index].toString(),
                  ),
                );
              }),
              itemExtent: 28,
              looping: false,
              onSelectedItemChanged: (int index) {
                // selectedBrightness = brightnessList[index];
                // connections.setBrightness(index);
                // setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  void setMonitorInDevice() {
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
  }
}

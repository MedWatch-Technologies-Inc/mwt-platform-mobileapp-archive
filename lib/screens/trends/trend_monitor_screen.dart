import 'package:flutter/material.dart';
import 'package:health_gauge/screens/device_management/device_management_helper.dart';
import 'package:health_gauge/screens/device_management/model/device_setting_model.dart';
import 'package:health_gauge/screens/trends/helper_widgets/trend_switch.dart';
import 'package:health_gauge/screens/trends/helper_widgets/trend_tile.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class TrendMonitorScreen extends StatelessWidget {
  TrendMonitorScreen({super.key});

  final DeviceManagementHelper _helper = DeviceManagementHelper();

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
              leading: IconButton(
                key: Key('clickOnBackButtonHRMonitoring'),
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
                StringLocalization.of(context).getText(StringLocalization.trends),
                style: TextStyle(
                    color: HexColor.fromHex('#62CBC9'), fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
            ),
          )),
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
              ValueListenableBuilder(
                valueListenable: _helper.deviceSettingNotifier,
                builder: (BuildContext context, DeviceSettingModel? value, Widget? child) {
                  return TrendTile(
                    title: StringLocalization.hrBPMonitoring,
                    selectedValue: _helper.deviceSettingNotifier.value?.hrMonitoring.status ?? true,
                    trendType: TrendType.hr,
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: _helper.deviceSettingNotifier,
                builder: (BuildContext context, DeviceSettingModel? value, Widget? child) {
                  return TrendTile(
                    title: StringLocalization.oxygenMonitoring,
                    selectedValue: _helper.deviceSettingNotifier.value?.oxygenMonitoring.status ?? true,
                    trendType: TrendType.spo2,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

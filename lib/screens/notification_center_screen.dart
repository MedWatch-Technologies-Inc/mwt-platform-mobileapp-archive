import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/reminders/app_reminders_screen.dart';
import 'package:health_gauge/screens/reminders/sleep_reminder.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';

import 'alarm_list_screen.dart';
import 'e80_alarm_list_screen.dart';
import 'reminders_screen.dart';

class NotificationCenterScreen extends StatefulWidget {
  @override
  _NotificationCenterState createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenterScreen> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex("#384341").withOpacity(0.2),
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
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
                icon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(
                        "asset/dark_leftArrow.png",
                        width: 13,
                        height: 22,
                      )
                    : Image.asset(
                        "asset/leftArrow.png",
                        width: 13,
                        height: 22,
                      ),
              ),
              title: Text(
                stringLocalization.getText(StringLocalization.notificationCenter),
                style: TextStyle(color: HexColor.fromHex("62CBC9"), fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ListView(
              children: [sleepReminder(), alarm(), appReminders(), reminders()],
            ),
          ],
        ),
      ),
    );
  }

  Widget sleepReminder() {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () {
          Constants.navigatePush(SleepReminder(), context);
        },
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            "asset/Wellness/sleepIcon.png",
            height: 33,
            width: 33,
          ),
        ),
        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.sleepReminder),
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex("#384341"),
        ),
        trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? "asset/right_setting_dark.png"
                  : "asset/right_setting.png",
              height: 14,
              width: 8,
            )));
  }

  Widget alarm() {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () async {
          var connectedDevice = await connections.checkAndConnectDeviceIfNotConnected();
          var alarmScreen;
          if (connectedDevice?.sdkType == 2) {
            alarmScreen = E80AlarmListScreen();
          } else {
            alarmScreen = AlarmListScreen();
          }
          Constants.navigatePush(alarmScreen, context).then((value) => screen = Constants.settings);
        },
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            "asset/alarm_icon.png",
            // height: 33,
            // width: 33,
          ),
        ),
        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.alarm),
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex("#384341"),
        ),
        trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? "asset/right_setting_dark.png"
                  : "asset/right_setting.png",
              height: 14,
              width: 8,
            )));
  }

  Widget appReminders() {
    return ListTile(
        onTap: () {
          Constants.navigatePush(AppRemindersScreen(), context);
        },
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            "asset/alarm_icon.png",
            // height: 33,
            // width: 33,
            color: Colors.transparent,
          ),
        ),
        title: Text(StringLocalization.of(context).getText(StringLocalization.appReminders)),
        trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? "asset/right_setting_dark.png"
                  : "asset/right_setting.png",
              height: 14,
              width: 8,
            )));
  }

  Widget reminders() {
    return ListTile(
        onTap: () {
          Constants.navigatePush(RemindersScreen(), context);
        },
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            "asset/alarm_icon.png",
            // height: 33,
            // width: 33,
            color: Colors.transparent,
          ),
        ),
        title: Text(StringLocalization.of(context).getText(StringLocalization.reminders)),
        trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? "asset/right_setting_dark.png"
                  : "asset/right_setting.png",
              height: 14,
              width: 8,
            )));
  }
}

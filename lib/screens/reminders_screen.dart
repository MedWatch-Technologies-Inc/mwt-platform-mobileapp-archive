import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/reminder_model.dart';
import 'package:health_gauge/screens/dashboard/dash_board_screen.dart';
import 'package:health_gauge/screens/reminders/add_reminder_screen.dart';

import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/reminder_notification.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home/home_screeen.dart';
import 'reminders/add_reminder_screen.dart';

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<ReminderModel> reminderList = [];

  bool isLoading = true;
  DatabaseHelper helper = DatabaseHelper.instance;

  

  String? userId;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

   DeviceModel? connectedDevice;

  @override
  void initState() {
    connections.checkAndConnectDeviceIfNotConnected().then((value) {
      connectedDevice = value;
      if(mounted){
        setState(() {});
      }
    });
    ReminderNotification.initialize();
    getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: Constants.width, height: Constants.height, allowFontScaling: true);
    return Scaffold(
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
                  Navigator.of(context).pop();
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
                StringLocalization.of(context)
                    .getText(StringLocalization.reminders),
                style: TextStyle(
                    color: HexColor.fromHex("#62CBC9"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              /* actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 15),
              icon: Image.asset("asset/plus.png", height: 18, width: 18,),
              onPressed: () async{
                final result = await Constants.navigatePush(AddReminderScreen(), context);
                if(result != null && result){
                  getPreferences();
                }
              }),
          */ /*IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: () async{
                ReminderNotification.showNotification();
              }),*/ /*
        ],*/
            ),
          )),
      body: mainLayout(context),
    );
  }

  Widget mainLayout(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: ListView.separated(
        itemCount: reminderList.length,
        itemBuilder: (BuildContext context, int index) {
          var model = reminderList[index];
          if(connectedDevice?.sdkType != Constants.zhBle){
            if(model != null && index == 1){
              return item(model);
            }
            return Container();
          } else if (model != null) {
            return item(model);
          }
          return Container();
        },
        separatorBuilder: (BuildContext context, int index) {
          if(connectedDevice?.sdkType != Constants.zhBle){
            return Container();
          }
          return Divider();
        },
      ),
    );
  }

  Widget item(ReminderModel model) {
    Widget imageWidget = Container(
      width: 1,
      height: 1,
    );
    if (model.imageBase64 != null && model.imageBase64!.isNotEmpty) {
      var urlPattern =
          r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
      RegExp regExp =
          new RegExp(urlPattern, caseSensitive: false, multiLine: false);
      if (regExp.hasMatch(model.imageBase64!)) {
        imageWidget = Image.network(
          model.imageBase64!,
          height: IconTheme.of(context).size,
          width: IconTheme.of(context).size,
        );
      } else {
        Uint8List bytes = base64Decode(model.imageBase64!);
        imageWidget = Image.memory(
          bytes,
          height: IconTheme.of(context).size,
          width: IconTheme.of(context).size,
        );
      }
    }
    return ListTile(
      onTap: () async {
        var result = await Constants.navigatePush(
            AddReminderScreen(model: model,connectedDevice: connectedDevice,), context);
        if (result != null && result) {
          getReminderList();
        }
      },
      leading: imageWidget,
      title: Text(model.label ?? ""),
      subtitle: Text(model.description ?? ""),
      trailing: CustomSwitch(
          value: model.isEnable ?? false,
          onChanged: (value) async {
            await onChangeValue(model, value);
          },
        activeColor: HexColor.fromHex("#00AFAA"),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex("#E7EBF2"),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.6) : HexColor.fromHex("#D1D9E6"),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark ? AppColor.darkBackgroundColor : HexColor.fromHex("#E7EBF2"),),
    );
  }

  Future onChangeValue(ReminderModel model, bool value) async {
    // Constants.progressDialog(true, context);
    model.isEnable = value;
    if (value) {
      if (model.isDefault != null && !model.isDefault!) {
        int sdkType = Constants.e66;
        try {
          sdkType = connectedDevice!.sdkType!;
        } catch (e) {
          print(e);
        }
        connections.setCustomReminder(model, model.id!, sdkType );
      }
      if (model.label!.toLowerCase() == "${stringLocalization.getText(StringLocalization.ppgReminderTitle)}".toLowerCase()) {
        ppgReminderModel.startTime =
            ReminderNotification.stringToTimeOfDay(model.startTime!);
        ppgReminderModel.endTime =
            ReminderNotification.stringToTimeOfDay(model.endTime!);
        ppgReminderModel.days =
            model.days!.where((m) => m["isSelected"]).toList();
        Duration? duration;
        if (model.interval!
            .contains(stringLocalization.getText(StringLocalization.minute))) {
          var a = model.interval!.replaceFirst(
              " ${stringLocalization.getText(StringLocalization.minute)}", "");
          duration = new Duration(minutes: int.parse(a));
        } else if (model.interval!
            .contains(stringLocalization.getText(StringLocalization.hour))) {
          var a = model.interval!.replaceFirst(
              " ${stringLocalization.getText(StringLocalization.hour)}", "");
          duration = new Duration(hours: int.parse(a));
        }
        if (duration != null) {
          ppgReminderModel.interval = ReminderNotification.getTimes(
                  ppgReminderModel.startTime!,
                  ppgReminderModel.endTime!,
                  duration)
              .toList();
        }
        ppgReminder(userId ?? "", connections);
      }
      await ReminderNotification.enableReminder(model);
    } else {
      if (model.isDefault != null && !model.isDefault!) {
        connections.cancelCustomReminder(model, model.id!);
      }else{
        if(model.reminderType == 1 || model.reminderType == 2 || model.reminderType == 3){
          connections.setDefaultReminder(model, model.reminderType, (connectedDevice?.sdkType??Constants.e66));
        }
        if(model.reminderType == 4){
          ppgReminderModel.startTime = ReminderNotification.stringToTimeOfDay(model.startTime!);
          ppgReminderModel.endTime = ReminderNotification.stringToTimeOfDay(model.endTime!);
          ppgReminderModel.days = model.days!.where((m) => m["isSelected"]).toList();
          Duration? duration;
          if (model.interval!.contains(stringLocalization.getText(StringLocalization.minute))) {
            var a = model.interval!.replaceFirst(
                " ${stringLocalization.getText(StringLocalization.minute)}", "");
            duration = new Duration(minutes: int.parse(a));
          } else if (model.interval!.contains(stringLocalization.getText(StringLocalization.hour))) {
            var a = model.interval!.replaceFirst(
                " ${stringLocalization.getText(StringLocalization.hour)}", "");
            duration = new Duration(hours: int.parse(a));
          }
          if (duration != null) {
            ppgReminderModel.interval = ReminderNotification.getTimes(
                ppgReminderModel.startTime!,
                ppgReminderModel.endTime!,
                duration)
                .toList();
          }
          ppgReminder(userId ?? "", connections);
        }
      }
      if (model.label!.toLowerCase() ==
          "${stringLocalization.getText(StringLocalization.ppgReminderTitle)}"
              .toLowerCase()) {
        if (timer != null && timer!.isActive) {
          timer!.cancel();
        }
      }
      await ReminderNotification.disableReminder(model);
    }
    var map = model.toMap();
    map["UserId"] = userId;
    await helper.insertUpdateReminder(map);

    await sendDataToDevice(model);

    // Constants.progressDialog(false, context);
    setState(() {});
  }

  Future sendDataToDevice(ReminderModel model) async {
    int sdkType = Constants.e66;
    try {
      sdkType = connectedDevice!.sdkType!;
    } catch (e) {
      print(e);
    }
    if (model.label!.toLowerCase() ==
        "${stringLocalization.getText(StringLocalization.waterReminderTitle)}"
            .toLowerCase()) {
      await connections.setDefaultReminder(model, 1, sdkType);
    } else if (model.label!.toLowerCase() ==
        "${stringLocalization.getText(StringLocalization.sedentaryReminderTitle)}"
            .toLowerCase()) {
      await connections.setDefaultReminder(model, 2, sdkType);
    } else if (model.label!.toLowerCase() ==
        "${stringLocalization.getText(StringLocalization.medicineReminderTitle)}"
            .toLowerCase()) {
      await connections.setDefaultReminder(model, 3, sdkType);
    }
    return Future.value();
  }

  getReminderList() async {
    if (preferences == null) {
      await getPreferences();
    }
    reminderList = await helper.getReminderList(userId ?? "");
    isLoading = false;
    setState(() {});
  }

  Future getPreferences() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? "";
    if (userId != null && userId!.isNotEmpty) {
      await getReminderList();
    }
  }


}

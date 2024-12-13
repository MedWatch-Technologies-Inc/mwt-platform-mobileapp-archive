import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/alarm_models/e80_alarm_list_model.dart';
import 'package:health_gauge/models/e80_set_alarm_model.dart';
import 'package:health_gauge/utils/alarm_notification.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/slider/flutter_slidable.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/custom_switch.dart';

import 'add_e80_alarm_screen.dart';

/// Added by: Akhil
/// Added on: July/24/2020
/// This widget is for showing alarm list
class E80AlarmListScreen extends StatefulWidget {
  @override
  _E80AlarmListScreenState createState() => _E80AlarmListScreenState();
}

/// Added by: Akhil
/// Added on: July/24/2020
/// This class maintains the state of E80AlarmListScreen
class _E80AlarmListScreenState extends State<E80AlarmListScreen> {
  bool isLoading = true;
  // DatabaseHelper helper = DatabaseHelper.instance;

  List<String> alarmType = [
    'Wake up',
    'Sleep',
    'Gym',
    'Medicine',
    'Date',
    'Party',
    'Meeting',
    'Defining',
  ];

  String? userId;
  int alarmCount = 0;
  int maxLimitNum = 5;

  List<E80SetAlarmModel> alarmList = <E80SetAlarmModel>[];
  E80AlarmListModel list = new E80AlarmListModel();

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This function gets value from shared preference.
  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This function is responsible for building UI.
  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
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
              StringLocalization.of(context).getText(StringLocalization.alarm),
              style: TextStyle(
                  color: HexColor.fromHex('62CBC9'),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  padding: EdgeInsets.only(right: 15),
                  icon: alarmCount < maxLimitNum
                      ? Image.asset(
                          'asset/plus.png',
                          width: 18,
                          height: 18,
                        )
                      : Container(),
                  onPressed: alarmCount < maxLimitNum
                      ? () async {
                          final result = await Constants.navigatePush(
                              AddE80AlarmScreen(), context);
                          if (result != null && result) {
                            getPreferences();
                          }
                        }
                      : () {}),
              /*IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: () async{
                ReminderNotification.showNotification();
              }),*/
            ],
          ),
        ),
      ),
      body: mainLayout(context),
    );
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This widget is the body of scaffold
  Widget mainLayout(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (alarmList.isEmpty) {
      return Center(
        child: Text('No Alarm Found'),
      );
    }
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: ListView.separated(
        itemCount: alarmList.length,
        itemBuilder: (BuildContext context, int index) {
          var model = alarmList[index];
          if (model != null) {
            return item(model, index);
          }
          return Container();
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1.h,
            indent: 0,
          );
        },
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This widget is the List Tile to show the Alarm Information
  Widget item(E80SetAlarmModel model, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: [
        IconSlideAction(
          boxDecoration: BoxDecoration(
            color: HexColor.fromHex('#FF6259'),
          ),
          // color: HexColor.fromHex("#FF6259"),
          onTap: () async {
            //delete alarm from device
            await connections.deleteAlarmInE80(model);
            var id = int.parse('${model.type}${model.delayTime}');
            AlarmNotification.disableReminder(
                days: model.days!,
                id: id,
                hour: model.hour!,
                minute: model.minute!);
            getAlarmList();
            CustomSnackBar.buildSnackbar(
                context, 'Alarm Deleted Successfully', 3);
          },
          // height: 56.h,
          topMargin: 0, //16.h,
          iconWidget: Text(
            StringLocalization.of(context).getText(StringLocalization.delete),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.backgroundColor,
            ),
          ),
          rightMargin: 2.w,
          leftMargin: 0,
        )
      ],
      child: ListTile(
        // contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.w),
        // visualDensity: VisualDensity(vertical: -1),
        dense: true,
        onTap: () async {
          var result = await Constants.navigatePush(
              AddE80AlarmScreen(
                model: model,
                isEdit: true,
              ),
              context);
          if (result != null && result) {
            getAlarmList();
          }
        },
        leading: Icon(Icons.alarm),
        title: Text(model.hour != null && model.minute != null
            ? getFormattedTime('${model.hour}:${model.minute}')
            : ''),
        subtitle: Text(alarmType[model.type ?? 0]),
        trailing: CustomSwitch(
          value: model.isAlarmEnable ?? false,
          onChanged: (value) async {
            await onChangeValue(model, value);
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
        ),
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This widget is to On/Off the alarm
  Future onChangeValue(E80SetAlarmModel model, bool value) async {
    Constants.progressDialog(true, context);
    model.isAlarmEnable = value;
    // var map = model.toMap();
    // map["UserId"] = userId;
    // await helper.updateAlarm(map);
    // if (model.id != null) {
    //
    // }
    await connections.modifyAlarmInE80(model);
    await resetNotification(model, value);
    Constants.progressDialog(false, context);
    setState(() {});
  }

  resetNotification(E80SetAlarmModel model, bool value) async {
    /// value = false: disable notification
    /// value = true: enable notification
    AlarmNotification().initialize();
    var id = int.parse('${model.type}${model.delayTime}');
    if (value) {
      var label =
          "${model.hour.toString().padLeft(2, "0")}:${model.minute.toString().padLeft(2, "0")}";
      await AlarmNotification().enableReminder(
          days: model.days!,
          id: id,
          hour: model.hour!,
          minute: model.minute!,
          label: label,
          description: alarmType[model.type!]);
    } else {
      await AlarmNotification.disableReminder(
        days: model.days!,
        id: id,
        hour: model.hour!,
        minute: model.minute!,
      );
    }
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This function is to get userId from shared preferences and call function to get Alarm List from database
  Future getPreferences() async {
    userId = preferences?.getString(Constants.prefUserIdKeyInt);
    if (userId != null && userId!.isNotEmpty) {
      await getAlarmList();
    }
  }

  Future<void> resetAlarms() async {
    for (int i = 0; i < alarmList.length; ++i) {
      await resetNotification(alarmList[i], false);
    }
    for (int i = 0; i < alarmList.length; ++i) {
      await resetNotification(alarmList[i], false);
    }
  }

  /// Added by: Akhil
  /// Added on: July/24/2020
  /// This function to get Alarm List from database
  getAlarmList() async {
    if (preferences == null) {
      await getPreferences();
    }
    var startTime = DateTime.now();

    Future.delayed(Duration(seconds: 15)).then((value) {
      if (mounted) {
        if (DateTime.now().difference(startTime).inSeconds >= 15 &&
            (alarmList.isEmpty) &&
            (isLoading)) {
          isLoading = false;
          CustomSnackBar.buildSnackbar(context,
              stringLocalization.getText(StringLocalization.requestTimeOUt), 3);
          setState(() {});
        }
      }
    });
    connections.getE80AlarmList().then(
      (list) async {
        alarmList.clear();
        list?.alarmData?.forEach((element) {
          alarmList.add(
            E80SetAlarmModel.fromModel(element),
          );
        });
        alarmCount = list!.alarmNum!;
        maxLimitNum = list.maxLimitNum!;
        isLoading = false;
        await resetAlarms();
        if (mounted) {
          setState(() {});
        }
      },
    ).catchError(
      (onError) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  getFormattedTime(String time) {
    try {
      var val = time.split(':');
      String newTime;
      if (val != null && val[1].length == 1) {
        newTime = val[0] + ':' + '0${val[1]}';
        return newTime;
      } else {
        return time;
      }
    } catch (e) {}
  }
}

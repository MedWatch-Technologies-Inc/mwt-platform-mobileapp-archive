import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/e80_set_alarm_model.dart';
import 'package:health_gauge/screens/loading_screen.dart';
import 'package:health_gauge/screens/reminders/model/sleep_reminder_model.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/reminder_notification.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/CustomTimePicker/time_picker.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class SleepReminder extends StatefulWidget {
  @override
  _SleepReminderState createState() => _SleepReminderState();
}

class _SleepReminderState extends State<SleepReminder> {
  TimeOfDay startTimeOfDay = TimeOfDay(hour: 22, minute: 0);

  //region days
  List days = [0, 0, 0, 0, 0, 0, 0];
  List daysName = [
    StringLocalization.mon,
    StringLocalization.tue,
    StringLocalization.wed,
    StringLocalization.thu,
    StringLocalization.fri,
    StringLocalization.sat,
    StringLocalization.sun
  ];

  //endregion
  bool enable = false;

  bool isLoading = true;

  E80SetAlarmModel? model;

  @override
  void initState() {
    getAlarmList();
    // getAndSetDataFromPreference();
    super.initState();
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
              StringLocalization.of(context).getText(StringLocalization.sleepReminder),
              style: TextStyle(
                  color: HexColor.fromHex("62CBC9"), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(
        children: [
          Visibility(
            visible: isLoading,
            child: LoadingScreen(),
          ),
          Visibility(
            visible: !isLoading,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    startTimeWidget(),
                    repetitionWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: !isLoading,
        child: Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 17.h, bottom: 23.h),
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.h),
                color: HexColor.fromHex("#00AFAA"),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                        : Colors.white,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(-5.w, -5.h),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.75)
                        : HexColor.fromHex("#D1D9E6"),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(5.w, 5.h),
                  ),
                ]),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30.h),
                onTap: () async {
                  onClickSave();
                },
                child: Container(
                  decoration: ConcaveDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.h),
                      ),
                      depression: 10,
                      colors: [
                        Colors.white,
                        HexColor.fromHex("#D1D9E6"),
                      ]),
                  //center
                  child: Center(
                    child: TitleText(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.save)
                          .toUpperCase(),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex("#111B1A")
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget startTimeWidget() {
    if (startTimeOfDay == null) {
      startTimeOfDay = TimeOfDay(hour: 22, minute: 0);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Display2Text(
          text:
              "${startTimeOfDay.hour.toString().padLeft(2, "0")}:${startTimeOfDay.minute.toString().padLeft(2, "0")}",
          align: TextAlign.center,
        ),
        TextButton(
          onPressed: () => onTapStartTime(),
          child: Text(
            stringLocalization.getText(StringLocalization.startTime),
            style: TextStyle(
              color: AppColor.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Column repetitionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SubTitleText(
          text: stringLocalization.getText(StringLocalization.selectDays),
        ),
        SizedBox(height: 10.h),
        Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(days.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: InkWell(
                onTap: () {
                  days[index] = days[index] == 0 ? 1 : 0;
                  // _invalidInput  = false;
                  setState(() {});
                },
                child: Container(
                  // alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primaryColor),
                    color: days[index] == 1 ? AppColor.primaryColor : Colors.transparent,
                  ),
                  padding: EdgeInsets.all(15.h),
                  child: Text(
                    stringLocalization.getText(daysName[index]),
                    style: TextStyle(
                      color: days[index] == 1 ? Colors.white : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        })),
        SizedBox(height: 13.h),
        // Visibility(
        //   visible: _invalidInput,
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: EdgeInsets.only(left: 11.w),
        //         child: Text(
        //           'Select days',
        //           style: TextStyle(color: Colors.red, fontSize: 14),
        //         ),
        //       ),
        //       SizedBox(height: 10.h),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget enableWidget() {
    return ListTile(
      title: Text(stringLocalization.getText(StringLocalization.enable)),
      trailing: CustomSwitch(
        value: enable,
        onChanged: (value) {
          enable = value;
          if (mounted) {
            setState(() {});
          }
        },
        activeColor: HexColor.fromHex("#00AFAA"),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex("#E7EBF2"),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex("#D1D9E6"),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex("#E7EBF2"),
      ),
    );
  }

  onTapStartTime() async {
    TimeOfDay? time = await showCustomTimePicker(
      initialTime: startTimeOfDay,
      context: context,
    );
    if (time != null) {
      startTimeOfDay = time;
      if (mounted) {
        setState(() {});
      }
    }
  }

  onClickSave() async {
    try {
      await setSleepReminder();
      if (mounted) {
        CustomSnackBar.buildSnackbar(context,
            stringLocalization.getText(StringLocalization.sleepReminderSetSuccessfully), 3);
        Navigator.of(context).pop();
      }

      /*SleepReminderModel model = SleepReminderModel();
      model.daysList = days;
      model.isEnable = enable;
      model.startTime = '${startTimeOfDay.hour}:${startTimeOfDay.minute}';
      model.userId = preferences.getString(Constants.prefUserIdKeyInt);
      preferences?.setString(Constants.sleepReminderModelKey, jsonEncode(model.toMap()));
      if(enable) {
            setNotification(model,startTimeOfDay);
          }else{
            removeNotification(model);
          }
      if(mounted){
            CustomSnackBar.buildSnackbar(context, stringLocalization.getText(StringLocalization.sleepReminderSetSuccessfully), 3);
            Navigator.of(context).pop();
          }*/
    } catch (e) {
      print('Exception at onClickSave $e');
    }
  }

  void setNotification(SleepReminderModel model, TimeOfDay time) {
    ReminderNotification.initialize();
    NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
      'your channel id',
      'your channel name',
    ));
    model.daysList!.forEach((map) async {
      if (map["isSelected"]) {
        var vibrationPattern = Int64List(4);
        vibrationPattern[0] = 0;
        vibrationPattern[1] = 1000;
        vibrationPattern[2] = 5000;
        vibrationPattern[3] = 2000;

        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          '${model.userId}',
          'Sleep Reminder',
          channelDescription: 'It\'s your sleep time, Don\'t forget to wear the bracelet.',
          vibrationPattern: vibrationPattern,
        );
        var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
        var d = "${model.userId}${map['day']}${time.hour}${time.minute}";
        ReminderNotification.flutterLocalNotificationsPlugin?.periodicallyShow(
          int.parse(d),
          'Sleep Reminder',
          'It\'s your sleep time, Don\'t forget to wear the bracelet.',
          RepeatInterval.weekly,
          platformChannelSpecifics,
        );
      }
    });
  }

  void removeNotification(SleepReminderModel model) {
    ReminderNotification.initialize();
    ReminderNotification.flutterLocalNotificationsPlugin?.cancel(int.parse(model.userId!));
  }

  static Iterable<TimeOfDay> getTimes(TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour || (hour == endTime.hour && minute <= endTime.minute));
  }

  void getAndSetDataFromPreference() {
    try {
      String sleepData = preferences?.getString(Constants.sleepReminderModelKey) ?? '';
      if (sleepData.isNotEmpty) {
        SleepReminderModel model = SleepReminderModel.fromMap(jsonDecode(sleepData));
        if (model != null) {
          days = model.daysList!;
          enable = model.isEnable ?? false;
          try {
            int hour = int.parse(model.startTime!.split(':')[0]);
            int minute = int.parse(model.startTime!.split(':')[1]);
            startTimeOfDay = TimeOfDay(
              hour: hour,
              minute: minute,
            );
          } catch (e) {
            print('Exception at getAndSetDataFromPreference $e');
          }
          Future.delayed(Duration(milliseconds: 100)).then((value) {
            if (mounted) {
              setState(() {});
            }
          });
        }
      }
    } catch (e) {
      print('Exception at getAndSetDataFromPreference $e');
    }
  }

  getAlarmList() async {
    var startTime = DateTime.now();

    Future.delayed(Duration(seconds: 15)).then((value) {
      if (mounted) {
        if (DateTime.now().difference(startTime).inSeconds >= 15 &&
            (model == null) &&
            (isLoading)) {
          isLoading = false;
          CustomSnackBar.buildSnackbar(
              context, stringLocalization.getText(StringLocalization.requestTimeOUt), 3);
          setState(() {});
        }
      }
    });
    connections.getE80AlarmList().then(
      (list) async {
        list?.alarmData?.forEach((element) {
          var model = E80SetAlarmModel.fromModel(element);
          if (model.type == 1) {
            this.model = model;
            setDefaultValues();
          }
        });
        isLoading = false;
        if (mounted) {
          setState(() {});
        }
      },
    ).catchError(
      (onError) {
        print('onError getAlarmList $onError');
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  E80SetAlarmModel addValueToModel() {
    E80SetAlarmModel alarmModel = new E80SetAlarmModel();
    if (model != null) {
      alarmModel = E80SetAlarmModel.clone(model!);
      if (alarmModel.hour != null && alarmModel.minute != null) {
        alarmModel.oldHr = alarmModel.hour;
        alarmModel.oldMin = alarmModel.minute;
      }
    }
    alarmModel.isAlarmEnable = true;
    alarmModel.hour = startTimeOfDay.hour;
    alarmModel.minute = startTimeOfDay.minute;
    alarmModel.type = 1;
    alarmModel.delayTime = 0;
    if (days != null) {
      alarmModel.days = days;
    }
    return alarmModel;
  }

  setSleepReminder() async {
    Constants.progressDialog(true, context);
    E80SetAlarmModel localModel = addValueToModel();
    model == null
        ? await connections.setAlarmInE80(localModel)
        : await connections.modifyAlarmInE80(localModel);
    Constants.progressDialog(false, context);
  }

  setDefaultValues() {
    if (model != null) {
      if (model!.hour != null && model!.minute != null) {
        int hour = model!.hour!;
        int minute = model!.minute!;
        startTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }
      if (model!.days != null && model!.days!.isNotEmpty) {
        days = model!.days!;
      }
    }
  }
}

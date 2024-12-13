import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_gauge/background_task.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/reminder_model.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'constants.dart';
import 'database_helper.dart';

class ReminderNotification {
  DatabaseHelper helper = DatabaseHelper.instance;

  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  static DeviceModel? connectedDevice;

  static initialize() async {
    if (flutterLocalNotificationsPlugin == null) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
      var initializationSettingsIOS = DarwinInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin?.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: selectNotification,
        onDidReceiveNotificationResponse: selectNotification,
      );
    }
  }

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  static Future selectNotification(NotificationResponse? notificationResponse) async {
//    NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//    print('result notification ${notificationAppLaunchDetails.didNotificationLaunchApp}');
//    Fluttertoast.showToast(msg: 'result notification ${notificationAppLaunchDetails.didNotificationLaunchApp}',backgroundColor: Colors.red);
//    if(notificationAppLaunchDetails.didNotificationLaunchApp) {
    var payload = notificationResponse?.payload ?? '';
    if (payload == 'PPG') {
      String? userId = getPreferences();
      if ((userId?.isNotEmpty ?? false) && !(userId?.contains('Skip') ?? false)) {
        Future.delayed(Duration(seconds: 5)).then((value) {
          BackgroundTask(connections: connections, userId: userId!).startMeasurement();
        });
      }
    } else if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    // }
  }

  static String? getPreferences() {
    return preferences?.getString(Constants.prefUserIdKeyInt);
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

  static Future showDailyAtTime(TimeOfDay time, int reminderId, ReminderModel model) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      '$reminderId',
      '${model.label}',
      channelDescription: '${model.description}',
      vibrationPattern: vibrationPattern,
    );
    var iOSPlatformChannelSpecifics = new DarwinNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    var d = '$reminderId${time.hour}${time.minute}';
    print('showDailyAtTime $d');
    flutterLocalNotificationsPlugin?.periodicallyShow(int.parse(d), model.label, model.description,
        RepeatInterval.daily, platformChannelSpecifics,
        payload: model.label?.toLowerCase() ==
                '${stringLocalization.getText(StringLocalization.ppgReminderTitle)}'.toLowerCase()
            ? 'PPG'
            : '');
  }

  static Future showWeekly(TimeOfDay time, day, int reminderId, ReminderModel model) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      '$reminderId',
      '${model.label}',
      channelDescription: '${model.description}',
      vibrationPattern: vibrationPattern,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    var d = '$reminderId$day${time.hour}${time.minute}';
    print('showWeekly $d');
    flutterLocalNotificationsPlugin?.periodicallyShow(int.parse(d), model.label, model.description, RepeatInterval.weekly, platformChannelSpecifics);
  }

  static Future cancelUserAllCustomReminder(String userId) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<ReminderModel> reminders = await databaseHelper.getReminderList(userId);
    reminders.forEach((model) async {
      if (!(model.isDefault ?? false)) {
        connections.cancelCustomReminder(model, model.id ?? 0);
      }
    });
  }

  static Future disableReminder(ReminderModel model) async {
    Duration? duration;
    TimeOfDay? startTimeOfDay;
    TimeOfDay? endTimeOfDay;
    if (model.startTime != null && (model.startTime?.isNotEmpty ?? false)) {
      int hour = int.tryParse(model.startTime?.split(':')[0] ?? '') ?? 0;
      int minute = int.tryParse(model.startTime?.split(':')[1] ?? '') ?? 0;
      startTimeOfDay = TimeOfDay(hour: hour, minute: minute);
    }
    if (model.endTime != null && model.endTime!.isNotEmpty) {
      int hour = int.parse(model.endTime!.split(':')[0]);
      int minute = int.parse(model.endTime!.split(':')[1]);
      endTimeOfDay = TimeOfDay(hour: hour, minute: minute);
    }
    if (model.interval?.contains(stringLocalization.getText(StringLocalization.minute)) ?? false) {
      var a = model.interval
          ?.replaceFirst(' ${stringLocalization.getText(StringLocalization.minute)}', '');
      duration = new Duration(minutes: int.tryParse(a ?? '') ?? 0);
    } else if (model.interval?.contains(stringLocalization.getText(StringLocalization.hour)) ??
        false) {
      var a = model.interval!
          .replaceFirst(' ${stringLocalization.getText(StringLocalization.hour)}', '');
      duration = new Duration(hours: int.parse(a));
    }

    if (model.startTime != null && model.startTime!.isNotEmpty) {
      int hour = int.parse(model.startTime!.split(':')[0]);
      int minute = int.parse(model.startTime!.split(':')[1]);
      startTimeOfDay = TimeOfDay(hour: hour, minute: minute);
    }
    if (model.endTime != null && model.endTime!.isNotEmpty) {
      int hour = int.parse(model.endTime!.split(':')[0]);
      int minute = int.parse(model.endTime!.split(':')[1]);
      endTimeOfDay = TimeOfDay(hour: hour, minute: minute);
    }
    if (startTimeOfDay != null && endTimeOfDay != null && duration != null) {
      List<TimeOfDay> intervals = getTimes(startTimeOfDay, endTimeOfDay, duration).toList();

      //region disable weekly
      int isWeeklyNotification = model.days?.indexWhere((m) => m['isSelected']) ?? 0;
      if (isWeeklyNotification != 1) {
        List list = model.days?.where((m) => m['isSelected']).toList() ?? [];
        for (int i = 0; i < list.length; i++) {
          for (int j = 0; j < intervals.length; j++) {
            var d = '${model.id}${list[i]['day']}${intervals[j].hour}${intervals[j].minute}';
            int id = int.parse(d);
            print('cancelled id ${list[i]['day']} $d');
            await flutterLocalNotificationsPlugin?.cancel(id);
          }
        }
      }

      //region disable daily
      for (int i = 0; i < intervals.length; i++) {
        var d = '${model.id}${intervals[i].hour}${intervals[i].minute}';
        int id = int.parse(d);
        print('cancelled id $d');
        await flutterLocalNotificationsPlugin?.cancel(id);
      }
      //endregion
    }
    //endregion

    if (model.isDefault != null && !(model.isDefault ?? false)) {
      connections.cancelCustomReminder(model, (model.id ?? 0));
    }
    return Future.value();
  }

  static Future enableReminder(ReminderModel model) {
    Duration? duration;
    TimeOfDay? startTimeOfDay;
    TimeOfDay? endTimeOfDay;
    if (model.startTime != null && model.startTime!.isNotEmpty) {
      int hour = int.parse(model.startTime!.split(':')[0]);
      int minute = int.parse(model.startTime!.split(':')[1]);
      startTimeOfDay = TimeOfDay(hour: hour, minute: minute);
    }
    if (model.endTime != null && model.endTime!.isNotEmpty) {
      int hour = int.parse(model.endTime!.split(':')[0]);
      int minute = int.parse(model.endTime!.split(':')[1]);
      endTimeOfDay = TimeOfDay(hour: hour, minute: minute);
    }
    if ((model.isNotification ?? false) && (model.isEnable ?? false)) {
      if (model.interval?.contains(stringLocalization.getText(StringLocalization.minute)) ??
          false) {
        String a = model.interval
                ?.replaceFirst(' ${stringLocalization.getText(StringLocalization.minute)}', '') ??
            '';
        duration = new Duration(minutes: int.tryParse(a) ?? 0);
      } else if (model.interval?.contains(stringLocalization.getText(StringLocalization.hour)) ??
          false) {
        String a = model.interval
                ?.replaceFirst(' ${stringLocalization.getText(StringLocalization.hour)}', '') ??
            '';
        duration = new Duration(hours: int.tryParse(a) ?? 0);
      }
      if (model.id != null && model != null) {
        if ((model.days?.where((element) => element['isSelected']).toList().length ?? 0) > 0) {
          model.days?.forEach((map) async {
            if (map['isSelected']) {
              List<TimeOfDay> intervals =
                  getTimes(startTimeOfDay!, endTimeOfDay!, duration!).toList();
              intervals.forEach((element) async {
                await showWeekly(element, map['day'], model.id!, model);
              });
              print('Day ${map['name']} : $intervals');
            }
          });
        } else {
          List<TimeOfDay> intervals = getTimes(startTimeOfDay!, endTimeOfDay!, duration!).toList();
          intervals.forEach((element) async {
            await showDailyAtTime(element, model.id!, model);
          });
        }
      }
    }
    return Future.value();
  }

  static Future showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = new DarwinNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        ?.show(0, 'plain title', 'plain body', platformChannelSpecifics, payload: 'item x');
  }

  static void disableAllNotification() {
    if (flutterLocalNotificationsPlugin != null) {
      flutterLocalNotificationsPlugin!.cancelAll();
    }
  }

  static Future enableAllByUserId(String userId) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List reminderList = await helper.getReminderList(userId);
    for (int i = 0; i < reminderList.length; i++) {
      ReminderModel model = reminderList[i];
      await enableReminder(model);
      if (model.isDefault != null && !(model.isDefault ?? false)) {
        int sdkType = Constants.e66;
        try {
          sdkType = connectedDevice?.sdkType ?? Constants.e66;
        } catch (e) {
          print(e);
        }
        connections.setCustomReminder(model, model.id ?? 0, sdkType);
      }
    }
  }

  static TimeOfDay? stringToTimeOfDay(String timeString) {
    if (timeString.isNotEmpty) {
      int hour = int.parse(timeString.split(':')[0]);
      int minute = int.parse(timeString.split(':')[1]);
      return TimeOfDay(hour: hour, minute: minute);
    }
  }
}

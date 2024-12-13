// ignore_for_file: prefer_single_quotes

import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_gauge/models/device_model.dart';

// import 'package:health_gauge/models/reminder_model.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'constants.dart';
import 'database_helper.dart';

class AlarmNotification {
  DatabaseHelper helper = DatabaseHelper.instance;

  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  static DeviceModel? connectedDevice;
  var platformChannelSpecifics;

  void initialize() async {
    tz.initializeTimeZones();
    // if (flutterLocalNotificationsPlugin == null) {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS =
        DarwinInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: selectNotification);
    // }

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
      var initializationSettingsIOS = DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'whin', // id
        'whin', // title
        channelDescription: 'This channel is used for important notifications.',
        playSound: true,
        enableVibration: true,
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
      );
      var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
      platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

      // showNotification(message);
    });
  }

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  static Future selectNotification(NotificationResponse? notificationResponse) async {
    var payload = notificationResponse?.payload ?? '';
    if (payload == "Alarm") {
      var userId = getPreferences();
      if (userId != null && userId.isNotEmpty && !userId.contains("Skip")) {
        // Future.delayed(Duration(seconds: 5)).then((value) {
        //   //todo on click
        //   BackgroundTask(connections: connections, userId: userId).startMeasurement();
        // });
      }
    } else if (payload != null) {
      debugPrint('notification payload: $payload');
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

  Future scheduleAtTime({
    required tz.TZDateTime time,
    required int id,
    required String label,
    required String description,
  }) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var key = "$id${time.hour}${time.minute}";
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '$key',
      '$label',
      channelDescription: '$description',
      vibrationPattern: vibrationPattern,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    print('showDailyAtTime $key');

    await flutterLocalNotificationsPlugin?.zonedSchedule(
        int.parse(key), label, description, time, platformChannelSpecifics,
        payload: 'Alarm',
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);

    // await flutterLocalNotificationsPlugin?.show(
    //     0, label, description, platformChannelSpecifics, payload: "Alarm");
  }

  static Future showDailyAtTime(
      {required TimeOfDay time,
      required int id,
      required String label,
      required String description}) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var key = "$id${time.hour}${time.minute}";
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '$key',
      '$label',
      channelDescription: '$description',
      vibrationPattern: vibrationPattern,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    print('showDailyAtTime $key');
    flutterLocalNotificationsPlugin?.periodicallyShow(
        int.parse(key), label, description, RepeatInterval.daily, platformChannelSpecifics,
        payload: 'Alarm');
  }

  static Future showWeekly(
      {required TimeOfDay time,
      required int day,
      required int id,
      required String label,
      required String description}) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    tz.TZDateTime _nextInstanceOfWeeklySchedule() {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, now.second);
      print(scheduledDate);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(minutes: 1));
      }
      return scheduledDate;
    }

    var key = "$id$day${time.hour}${time.minute}";
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '$key',
      '$label',
      channelDescription: '$description',
      vibrationPattern: vibrationPattern,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    print('showWeekly $key');
    flutterLocalNotificationsPlugin?.zonedSchedule(
      int.parse(key),
      label,
      description,
      _nextInstanceOfWeeklySchedule(),
      NotificationDetails(
        android: AndroidNotificationDetails(
          '$key',
          '$label',
          channelDescription: '$description',
          importance: Importance.max,
          priority: Priority.max,
          enableLights: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'Alarm',
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static Future<bool> getPending(int id) async {
    final List<PendingNotificationRequest>? pendingNotificationRequests =
        await flutterLocalNotificationsPlugin?.pendingNotificationRequests();
    return (pendingNotificationRequests?.indexWhere((element) => element.id == id) ?? -1) > -1;
  }

  // static Future cancelUserAllCustomReminder(String userId) async {
  //   DatabaseHelper databaseHelper = DatabaseHelper.instance;
  //   List<ReminderModel> reminders =
  //       await databaseHelper.getReminderList(userId);
  //   if (reminders != null) {
  //     reminders.forEach((model) async {
  //       if (connections != null && !model.isDefault) {
  //         connections.cancelCustomReminder(model, model.id);
  //       }
  //     });
  //   }
  // }

  static Future disableReminder({
    required List days,
    required int id,
    required int hour,
    required int minute,
  }) async {
    //region disable weekly
    int isWeeklyNotification = days == null ? -1 : days.indexWhere((m) => m == 1);
    if (isWeeklyNotification >= 0) {
      for (int i = 0; i < days.length; i++) {
        if (days[i] == 1) {
          var key = int.parse("$id${(i + 1) % 7 + 1}$hour$minute");
          print('cancelled id ${i + 1} $key');
          bool isExist = await getPending(key);
          if (isExist) await flutterLocalNotificationsPlugin?.cancel(key);
        }
      }
    }
    //endregion
    else {
      var key = int.parse("$id$hour$minute");
      print('cancelled id $key');
      bool isExist = await getPending(key);
      if (isExist) await flutterLocalNotificationsPlugin?.cancel(key);
    }
    // if (model.isDefault != null && !model.isDefault) {
    //   connections.cancelCustomReminder(model, model.id);
    // }
    return Future.value();
  }

  Future enableReminder({
    required List days,
    required int id,
    required int hour,
    required int minute,
    required String label,
    required String description,
  }) {
    // Duration duration;
    var timeOfDay = TimeOfDay(hour: hour, minute: minute);
    if (days.where((element) => element == 1).toList().length > 0) {
      var dayIndex = 1;
      Future.forEach(days, (dayValue) async {
        if (dayValue == 1) {
          showWeekly(
              time: timeOfDay,
              day: dayIndex % 7 + 1,
              id: id,
              label: label,
              description: description);
          print('Day $dayIndex');
        }
        print('Day $dayIndex');
        ++dayIndex;
      });
      // DateTime currentTime = DateTime.now();
      // TimeOfDay curTime =
      //     TimeOfDay(hour: currentTime.hour, minute: currentTime.minute);
      // showWeekly(
      //     time: curTime,
      //     day: dayIndex,
      //     id: 1,
      //     label: 'Current notification',
      //     description: 'description');
    } else {
      var currentTime = tz.TZDateTime.now(tz.local);
      var alarmTime = tz.TZDateTime(
          tz.local, currentTime.year, currentTime.month, currentTime.day, hour, minute);
      if (alarmTime.isBefore(currentTime)) {
        alarmTime = alarmTime.add(const Duration(days: 1));
      }
      scheduleAtTime(time: alarmTime, id: id, label: label, description: description);
      // scheduleAtTime(
      //     time: currentTime.add(Duration(seconds: 1)),
      //     id: 1,
      //     label: 'Current notification',
      //     description: 'description');
    }
    return Future.value();
  }

  // static Future showNotification() async {
  //   var androidPlatformChannelSpecifics =  AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.max, priority: Priority.high);
  //   var iOSPlatformChannelSpecifics =  IOSNotificationDetails();
  //   var platformChannelSpecifics =  NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       iOS: iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin?.show(
  //       0, 'plain title', 'plain body', platformChannelSpecifics,
  //       payload: 'item x');
  // }

  void showNotification(RemoteMessage message) async {
    await flutterLocalNotificationsPlugin?.show(
        0, message.notification!.title, message.notification!.body, platformChannelSpecifics,
        payload: jsonEncode(message.data));
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("background mode call");
    showNotification(message);
  }

  static void disableAllNotification() {
    if (flutterLocalNotificationsPlugin != null) {
      flutterLocalNotificationsPlugin?.cancelAll();
    }
  }

  // static Future enableAllByUserId(String userId) async {
  //   DatabaseHelper helper = DatabaseHelper.instance;
  //   List reminderList = await helper.getReminderList(userId);
  //   for(int i =0;i<reminderList.length;i++){
  //     ReminderModel model = reminderList[i];
  //     if(model != null){
  //       await enableReminder(model);
  //       if(model.isDefault != null && !model.isDefault){
  //         int sdkType = Constants.e66;
  //         try {
  //           sdkType = connectedDevice?.sdkType;
  //         } catch (e) {
  //           print(e);
  //         }
  //         connections.setCustomReminder(model,model.id,sdkType??Constants.zhBle);
  //       }
  //     }
  //   }
  // }

  static TimeOfDay stringToTimeOfDay(String timeString) {
    int hour = int.parse(timeString.split(":")[0]);
    int minute = int.parse(timeString.split(":")[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}

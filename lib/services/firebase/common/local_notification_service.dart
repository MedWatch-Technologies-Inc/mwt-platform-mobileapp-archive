import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    final initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    //create channel

    final initializationSettingsIOS = DarwinInitializationSettings(onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      await onSelectNotification(payload);
    });

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotificationInitially,
      onDidReceiveBackgroundNotificationResponse: onSelectNotificationInitially,
    );
  }

  /// Check if notification was tapped when app was killed, and fire onSelectNotification handler.
  /// NOTE: This should be called right after `initialize` is called, on app start.
  ///
  /// Solves https://github.com/MaikuB/flutter_local_notifications/issues/93
  void didNotificationLaunchApp() async {
    final notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      await onSelectNotification(notificationAppLaunchDetails?.notificationResponse?.payload ?? '');
    }
  }

// ongoing notification details
  NotificationDetails _standardNotification({
    required String notificationChannelId,
    required String notificationChannelName,
    required String notificationChannelDes,
    bool isOngoing = false,
  }) {
    final androidChannelSpecifics = AndroidNotificationDetails(
      notificationChannelId,
      notificationChannelName,
      channelDescription: notificationChannelDes,
      importance: Importance.max,
      priority: Priority.high,
      ongoing: isOngoing,
      //This is for the expanded notification bar
      styleInformation: BigTextStyleInformation(''),
    );

    final iOSChannelSpecifics = DarwinNotificationDetails(
      presentBadge: true,
    );

    return NotificationDetails(android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
  }

  Future onSelectNotification(String? payload) async {
    // TODO: Common This is to be handled by the domain services
  }

  Future onSelectNotificationInitially(NotificationResponse? payload) async {
    // TODO: Common This is to be handled by the domain services
  }

  // On going notification
  /// Below params are only for [Android] by default is for Email domain
  /// [notificationChannelId] This is the notification channel id,
  /// we can use this id for the clear all the push from the particular channel
  /// [notificationChannelName] This is the notification channel name shown under App Settings
  /// [notificationChannelDes] Description of the notification channel
  Future<void> showStandardNotification(
      {required String? title,
      required String? body,
      required String notificationChannelId,
      required String notificationChannelName,
      required String notificationChannelDes,
      int id = 0,
      String? payload}) async {
    return _showNotification(
      _flutterLocalNotificationsPlugin,
      title: title,
      body: body,
      id: id,
      payload: payload,
      type: _standardNotification(
          isOngoing: false,
          notificationChannelId: notificationChannelId,
          notificationChannelName: notificationChannelName,
          notificationChannelDes: notificationChannelDes),
    );
  }

  // FUNCTIONS FOR NOTIFICATIONS
  Future _showNotification(
    FlutterLocalNotificationsPlugin notifications, {
    required String? title,
    required String? body,
    required NotificationDetails type,
    String? payload,
    int id = 0,
  }) {
    return notifications.show(id, title, body, type, payload: payload);
  }

  // schedule notification
  Future showScheduleNotification({
    required String title,
    required String body,
    required Duration duration,
    required String notificationChannelId,
    required String notificationChannelName,
    required String notificationChannelDes,
    int? badgeNumber,
    String? payload,
    int id = 1,
  }) {
    print(
        'Schedule notification started will show after ${duration.inMinutes} minutes ${duration.inSeconds} seconds');
    return _showScheduleNotification(
      _flutterLocalNotificationsPlugin,
      title: title,
      body: body,
      id: id,
      payload: payload,
      type: _standardNotification(
        notificationChannelId: notificationChannelId,
        notificationChannelName: notificationChannelName,
        notificationChannelDes: notificationChannelDes,
      ),
      duration: duration,
    );
  }

  Future _showScheduleNotification(
    FlutterLocalNotificationsPlugin notifications, {
    required String title,
    required String body,
    required Duration duration,
    required NotificationDetails type,
    String? payload,
    int id = 0,
  }) {
    var tzDateTime = tz.TZDateTime.now(tz.local);
    return notifications.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      type,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Only for [Android]
  void deleteNotification(String channel) {
    // This is for Calendar domain
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channel);
  }

  /// Only for [Android],
  /// To remove the notification from system tray using the notification id.
  Future<void> cancelNotificationWithID(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

//TODO: clear push in iOS
  /// Only for [iOS]
//  Future<void> cancelID(int id) async {
//    await _flutterLocalNotificationsPlugin.cancel(id);
//  }
}

import 'package:health_gauge/services/logging/logging_service.dart';

class PushNotificationHandler {
  factory PushNotificationHandler() {
    return PushNotificationHandler._internal();
  }



  PushNotificationHandler._internal();

  Future<void> onMessage(Map<String, dynamic> messageData) async {
    LoggingService().printLog(
        message: 'PushNotificationHandler.onMessage message==> $messageData');
    // TODO: show LocalNotification
  }

  static Future<void> onBackgroundMessage(
      Map<String, dynamic> messageData) async {
    LoggingService().printLog(
        message:
            'FirebaseCloudMessaging.myBackgroundMessageHandler message==> $messageData');

    // TODO: show LocalNotification
  }
}

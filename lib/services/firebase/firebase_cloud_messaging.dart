import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/services/storage/storage_service.dart';

import 'common/push_notification_handler.dart';

class FirebaseCloudMessaging {

  static final FirebaseCloudMessaging getInstance = FirebaseCloudMessaging._();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final _fireStoreDB = FirebaseFirestore.instance;

  static final StorageService _storageService = StorageService.getInstance;
  FirebaseCloudMessaging._();
  Future<void> init() async {
    _configure();
  }

  void _configure() {
    // called when app in foreground (Android only)
    FirebaseMessaging.onMessage.listen(_onMessage);
    // called when the app in background or killed (Android only)
    if (Platform.isAndroid) {
      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    }
  }

  //To test _backgroundMessageHandler locally, Make workaround change in flutter sdk, suggested in below link.
  //https://github.com/FirebaseExtended/flutterfire/issues/4424#issuecomment-772750576
  //Otherwise, It will give error:
  //**I/flutter (15676): FlutterFire Messaging: An error occurred in your background messaging handler:
  //**I/flutter (15676): MissingPluginException(No implementation found for method getAll on channel plugins.flutter.io/shared_preferences)
  //**
  // called when the app in background or killed (Android only)
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    var messageData = message.data;
    if (messageData.isEmpty) {
      LoggingService().printLog(
          message:
              'FirebaseCloudMessaging.myBackgroundMessageHandler messageData is null or isEmpty');
      return;
    }

    await PushNotificationHandler.onBackgroundMessage(messageData);
  }

  ///TODO:Need to optimize the code
  // called when app in foreground (Android only)
  Future<void> _onMessage(RemoteMessage message) async {
    var messageData = message.data;

    if (messageData.isEmpty) {
      LoggingService().printLog(
          message:
              'FirebaseCloudMessaging._onMessage messageData is null or isEmpty');
      return;
    }

    await PushNotificationHandler().onMessage(messageData);
  }
}

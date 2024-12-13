import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:health_gauge/resources/db/app_preferences_handler.dart';
import 'package:health_gauge/services/analytics/sentry_analytics.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/app_init_logs.dart';
import 'package:health_gauge/services/core_util/bloc_delegate.dart';
import 'package:health_gauge/services/core_util/device_utils.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Bloc.observer = SimpleBlocDelegate();
  await FlutterDownloader.initialize(
      debug: kDebugMode ||
          kProfileMode // optional: set false to disable printing logs to console
      );
  await SystemInfoHelpers.getInstance.init();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
    Zone.current.handleUncaughtError(details.exception, details.stack!);
    await FirebaseCrashlytics.instance.recordFlutterError(details);
  };
  WidgetsFlutterBinding.ensureInitialized();
  await LoggingService().init();
  preferences = await SharedPreferences.getInstance();
  await AppPreferencesHandler().appInit();
  ServiceManager.init(
    baseUrl: Constants.baseUrl,
    isDebug: kDebugMode || kProfileMode,
    logApiFailure: true,
    logApiCallWithBasicData: true,
  );
  await SentryAnalytics().init(logOnServer: !kDebugMode);
  AppInitLogs.instance.log('main');
  runZonedGuarded(() {
    AppInitLogs.instance.log('main');
    WidgetsFlutterBinding.ensureInitialized();
    runApp(MyApp());
  }, (error, stackTrace) async {
    LoggingService().warning('Synchronization', 'Exception found',
        error: error, stackTrace: stackTrace);
    SentryAnalytics().captureException(error, stackTrace);
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    LoggingService().printLog(
        tag: 'Main', message: 'runZonedGuarded exception: $stackTrace');
  });
}

import 'dart:io';

import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_gauge/services/logging/contracts/logger_contract.dart';
import 'package:health_gauge/services/logging/core/logging_levels.dart';
import 'package:health_gauge/services/logging/core/logging_service_record.dart';

//import 'package:datadog_flutter/datadog_flutter.dart';
//import 'package:datadog_flutter/datadog_logger.dart';
//import 'package:datadog_flutter/datadog_rum.dart';
//import 'package:datadog_flutter/datadog_tracing.dart';
import 'package:logging/logging.dart';

class DatadogLogsService extends LoggerContract {
  String? currentUser;
  static const dataDogClientToken = 'pube07d3bdccfc8715a264cea0cc79ef8f5';

  @override
  Future<void> init() async {
    /*await DatadogFlutter.initialize(
      clientToken: dataDogClientToken,
      androidRumApplicationId: 'com.medwatch.mw',
      iosRumApplicationId: 'com.medwatch',
      serviceName: 'Med watch Mobile App',
      trackingConsent: TrackingConsent.granted,
    );

    FlutterError.onError = DatadogRum.instance.addFlutterError;
    await DatadogTracing.initialize();
    await DatadogFlutter.setUserInfo(id: currentUser);*/

    final configuration = DdSdkConfiguration(
      env: 'staging',
      site: DatadogSite.us1,
      clientToken: dataDogClientToken,
      loggingConfiguration: LoggingConfiguration(
        sendNetworkInfo: true,
        printLogsToConsole: true,
      ),
      rumConfiguration: RumConfiguration(
          applicationId: Platform.isIOS ? 'com.medwatch': Platform.isAndroid ? 'com.medwatch.mw' : ''
      ),
      //androidRumApplicationId: 'com.medwatch.mw',
      //iosRumApplicationId: 'com.medwatch',
      serviceName: 'Med watch Mobile App',
      trackingConsent: TrackingConsent.granted,
    );


    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      DatadogSdk.instance.rum?.handleFlutterError(details);
      originalOnError?.call(details);
    };

    await DatadogSdk.instance.initialize(configuration);
    DatadogSdk.instance.setUserInfo(id: currentUser);
  }

  @override
  void log(LoggingServiceRecord record) {
    switch (record.level) {
      case LoggingLevels.shout:
        dataDogLog(Level.SHOUT, record);
        break;
      case LoggingLevels.fine:
        dataDogLog(Level.FINE, record);
        break;
      case LoggingLevels.config:
        dataDogLog(Level.CONFIG, record);
        break;
      case LoggingLevels.all:
        dataDogLog(Level.ALL, record);
        break;
      case LoggingLevels.finer:
        dataDogLog(Level.FINER, record);
        break;
      case LoggingLevels.finest:
        dataDogLog(Level.FINEST, record);
        break;
      case LoggingLevels.warning:
        dataDogLogError(record);
        break;
      case LoggingLevels.severe:
        dataDogLog(Level.SEVERE, record);
        break;
      case LoggingLevels.info:
        dataDogLog(Level.INFO, record);
        break;
      default:
        dataDogLog(Level.OFF, record);
    }
  }

  @override
  void setUserInfo(String? id) {
    currentUser = id;
  }

  @override
  void unSetUserInfo() {
    currentUser = null;
  }

  void dataDogLog(Level level, LoggingServiceRecord record) {

    //level.value

    DatadogSdk.instance.logs?.info(record.toString(), errorKind: level.name,attributes: {
      'durationInMilliseconds': DateTime.now().millisecondsSinceEpoch,
      'userId': currentUser,
    });

    // DatadogLogger().log(record.toString(), level, attributes: {
    //   'durationInMilliseconds':
    //   DateTime.now().millisecondsSinceEpoch,
    //   'userId': currentUser,
    // });
  }

  void dataDogLogError(LoggingServiceRecord record) {
    if (record.stackTrace != null) {

      /*DatadogSdk.instance.logs
          ?.error(record.toString(), errorStackTrace: record.stackTrace!);*/

      DatadogSdk.instance.rum?.addError(
          record.toString(), RumErrorSource.custom,
          stackTrace: record.stackTrace!);

      //DatadogRum.instance.addError(record.toString(), record.stackTrace!);
    }
  }
}

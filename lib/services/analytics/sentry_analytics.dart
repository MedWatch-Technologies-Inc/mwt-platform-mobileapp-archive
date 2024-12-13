import 'dart:async';

import 'package:health_gauge/services/core_util/device_utils.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryAnalytics {
  static final SentryAnalytics _singleton = SentryAnalytics._internal();
  static final bool _trackApiMisuse = true;
  bool _logOnServer = false;

  factory SentryAnalytics() {
    return _singleton;
  }

  SentryAnalytics._internal();

  Future<void> init({bool logOnServer = false}) async {
    _logOnServer = logOnServer;
    if (_logOnServer) {
      await SentryFlutter.init((options) {
        options.dsn = 'https://af7684257b23414dbd2834ec2965b940@o850479.ingest.sentry.io/5817497';
        //'https://25947cdcb7f945978f9c580af7eddf94@o533488.ingest.sentry.io/5653009';
        //'https://489605bc51354982811fad6038c84bae@o954494.ingest.sentry.io/5903816';
      });
    } else {
      LoggingService().printLog(message: 'Not initialising Sentry in debug mode');
    }
  }

  void captureException(error, stackTrace) {
    if (_logOnServer) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    } else {
      LoggingService().printLog(message: error.toString());
    }
  }

  Future<void> setUserScope(String userId, String email) async {
    var model = SystemInfoHelpers.getInstance.deviceInfoModel;
    if (_logOnServer) {
      Sentry.configureScope(
        (scope) => scope.setUser(
          SentryUser(id: userId, email: email, extras: model.toJsonMap()),
        ),
      );
    } else {
      LoggingService().printLog(message: model.toJsonMap().toString());
    }
  }

  void apiTracking(Map<String, dynamic>? map) {
    if (map != null && map.isNotEmpty && _trackApiMisuse && _logOnServer) {
      var message = map.toString();
      Sentry.captureMessage(message,
          level: SentryLevel.debug,
          template: 'ApiMismatchCheck',
          hint: Hint.withMap({'hint': 'Debugging if api\'s are being misused or not'}));
    }
  }

  void unsetUserScope() {
    if (_logOnServer) {
      Sentry.configureScope((scope) => scope.setUser(null));
    } else {
      LoggingService().printLog(message: 'user data unset');
    }
  }

  void addBreadCrumb({String? message, Map? data}) {
    if (_logOnServer) {
      Sentry.addBreadcrumb(Breadcrumb(message: message));
    } else {
      LoggingService().printLog(message: 'Breadcrumb: message');
    }
  }

  void setContexts({required String event, Map? data}) {
    if (_logOnServer) {
      Sentry.configureScope((scope) => scope.setContexts(event, data));
    } else {
      LoggingService()
          .printLog(message: 'Event: $event, data: ${data != null ? data.toString() : 'null'}');
    }
  }
}

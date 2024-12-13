import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:health_gauge/services/logging/core/logging_levels.dart';
import 'package:health_gauge/services/logging/helpers/datadog_logs_service.dart';
import 'package:health_gauge/services/logging/helpers/firebase_logs_service.dart';
import 'package:health_gauge/services/logging/helpers/flutter_logs_service.dart';
import 'package:logger/logger.dart';

import 'contracts/logger_contract.dart';
import 'core/logging_service_record.dart';

enum ServerSideLogging {
  off,
  firebase,
  datadog,
}

class LoggingService {
  static final LoggingService _instance = LoggingService._();

  factory LoggingService() {
    return _instance;
  }

  LoggingService._();

  LoggerContract? _defaultLoggingService;
  LoggerContract? _serverSideLoggingService;

  Future<void> init({ServerSideLogging serverSideLogging=ServerSideLogging.datadog}) async {


    //  _defaultLoggingService = FlutterLogsService();

    if (_defaultLoggingService != null) {
      await _defaultLoggingService!.init();
    }

    if (serverSideLogging == ServerSideLogging.firebase) {
      _serverSideLoggingService = FirebaseLogsService();
    } else if (serverSideLogging == ServerSideLogging.datadog) {
      _serverSideLoggingService = DatadogLogsService();
    }

    if (_serverSideLoggingService != null) {
      await _serverSideLoggingService!.init();
    }
  }

  void logMessage(String message) {
    _logRecord(LoggingLevels.severe, 'API', message);
  }

  void setUserInfo(String? id) {
    if (_serverSideLoggingService != null) {
      _serverSideLoggingService!.setUserInfo(id);
    }
    if (_defaultLoggingService != null) {
      _defaultLoggingService!.setUserInfo(id);
    }
  }

  void unSetUserInfo() {
    if (_serverSideLoggingService != null) {
      _serverSideLoggingService!.unSetUserInfo();
    }
    if (_defaultLoggingService != null) {
      _defaultLoggingService!.unSetUserInfo();
    }
  }

  void _logRecord(LoggingLevels level, String featureName, String message,
      {String? className,
      String? methodName,
      Object? error,
      StackTrace? stackTrace}) {
    var record = LoggingServiceRecord(
      level,
      featureName,
      message,
      className: className,
      methodName: methodName,
      error: error,
      stackTrace: stackTrace,
    );

    if (_defaultLoggingService != null) {
      _defaultLoggingService!.log(record);
    }
    if (_serverSideLoggingService != null) {
      _serverSideLoggingService!.log(record);
    }
  }

  /// Holds instances of logger to send log messages to the [LogPrinter].
  final Logger _logger = Logger();

  static final JsonEncoder _prettyJsonEncoder = JsonEncoder.withIndent('  ');

  void printLog({String tag = '!@#', String message = ''}) {
    if (!kReleaseMode) {
      print('$tag: $message');
    }
  }

  /// If you are using printLog() and output is too much at once,
  /// then Android sometimes discards some log lines.
  /// To avoid this, use debugPrintLog().
  void debugPrintLog({String tag = '!@#', String message = ''}) {
    if (!kReleaseMode) {
      debugPrint('$tag: $message');
    }
  }

  void printLogger(
      {String tag = '!@#', String message = '', bool isJson = false}) {
    if (!kReleaseMode) {
      isJson
          ? printPrettyJsonString(tag: tag, jsonString: message)
          : _logger.d('$tag: $message');
    }
  }

  /// converts raw json string to human readable with proper indentation
  /// and new line
  ///
  /// {"data":"","error":""} to
  ///
  /// {
  ///  "data": "",
  ///  "error": ""
  /// }
  ///
  String? prettyString(String? jsonString) {
    if (jsonString == null) return null;
    try {
      return _prettyJsonEncoder.convert(json.decode(jsonString));
    } on Exception catch (e) {
      return 'Unable to parse\n $e';
    }
  }

  /// print json string in human readable
  /// [info] optional prefix of output json
  void printPrettyJsonString({String? jsonString, String tag = '!@#'}) {
    _logger.d('$tag\n${prettyString(jsonString)}');
  }

  void printBigLog({String tag = '!@#', String message = ''}) {
    if (!kReleaseMode) {
      final pattern = RegExp('.{1,800}'); //Setting 800 as size of each chunk
      pattern.allMatches(message).forEach((element) {
        print(element.group(0));
      });
    }
  }

  void config(String featureName, String message,
      {String? className,
      String? methodName,
      Object? error,
      StackTrace? stackTrace}) {
    _logRecord(LoggingLevels.config, featureName, message,
        className: className,
        methodName: methodName,
        error: error,
        stackTrace: stackTrace);
  }

  void fine(String featureName, String message,
      {String? className,
      String? methodName,
      Object? error,
      StackTrace? stackTrace}) {
    _logRecord(LoggingLevels.fine, featureName, message,
        className: className,
        methodName: methodName,
        error: error,
        stackTrace: stackTrace);
  }

  void finer(String featureName, String message,
      {String? className,
      String? methodName,
      Object? error,
      StackTrace? stackTrace}) {
    _logRecord(LoggingLevels.finer, featureName, message,
        className: className,
        methodName: methodName,
        error: error,
        stackTrace: stackTrace);
  }

  void finest(String featureName, String message,
      {String? className,
      String? methodName,
      Object? error,
      StackTrace? stackTrace}) {
    _logRecord(LoggingLevels.finest, featureName, message,
        className: className,
        methodName: methodName,
        error: error,
        stackTrace: stackTrace);
  }

  void info(String featureName, String message,
      {String? className,
      String? methodName,
      Object? error,
      StackTrace? stackTrace}) {
    _logRecord(LoggingLevels.info, featureName, message,
        className: className,
        methodName: methodName,
        error: error,
        stackTrace: stackTrace);
  }

  void severe(String featureName, String message,
      {String? className,
      String? methodName,
      Object? error,
      StackTrace? stackTrace}) {
    _logRecord(LoggingLevels.severe, featureName, message,
        className: className,
        methodName: methodName,
        error: error,
        stackTrace: stackTrace);
  }

  void warning(String featureName, String message,
      {String? className,
      String? methodName,
      Object? error,
      StackTrace? stackTrace}) {
    _logRecord(LoggingLevels.warning, featureName, message,
        className: className,
        methodName: methodName,
        error: error,
        stackTrace: stackTrace);
  }

  void shout(String featureName, String message,
      {String? className,
      String? methodName,
      Object? error,
      StackTrace? stackTrace}) {
    _logRecord(LoggingLevels.shout, featureName, message,
        className: className,
        methodName: methodName,
        error: error,
        stackTrace: stackTrace);
  }
}

import 'dart:async';

import 'package:flutter_logs/flutter_logs.dart';
import 'package:health_gauge/services/logging/contracts/logger_contract.dart';
import 'package:health_gauge/services/logging/core/logging_service_record.dart';

class FlutterLogsService extends LoggerContract {
  final String _tag = 'MyApp';
  final String _myLogFileName = 'hg_logfile';

  @override
  Future<void> init() async {
    Completer _completer = Completer<String>();

    await FlutterLogs.initLogs(
        logLevelsEnabled: [
          LogLevel.INFO,
          LogLevel.WARNING,
          LogLevel.ERROR,
          LogLevel.SEVERE
        ],
        timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
        directoryStructure: DirectoryStructure.FOR_DATE,
        logTypesEnabled: [_myLogFileName],
        logFileExtension: LogFileExtension.LOG,
        logsWriteDirectoryName: 'MyLogs',
        logsExportDirectoryName: 'MyLogs/Exported',
        debugFileOperations: true,
        isDebuggable: true);

    // [IMPORTANT] The first log line must never be called before 'FlutterLogs.initLogs'
    FlutterLogs.logInfo(_tag, 'setUpLogs', 'setUpLogs: Setting up logs.');

    // Logs Exported Callback
    FlutterLogs.channel.setMethodCallHandler((call) async {
      if (call.method == 'logsExported') {
        // Contains file name of zip
        FlutterLogs.logInfo(
            _tag, 'setUpLogs', 'logsExported: ${call.arguments.toString()}');

        // Notify Future with value
        _completer.complete(call.arguments.toString());
      } else if (call.method == 'logsPrinted') {
        FlutterLogs.logInfo(
            _tag, 'setUpLogs', 'logsPrinted: ${call.arguments.toString()}');
      }
    });
  }

  @override
  void setUserInfo(String? id) {
    // TODO: implement setUserInfo
  }

  @override
  void unSetUserInfo() {
    // TODO: implement unSetUserInfo
  }

  @override
  void log(LoggingServiceRecord record) {
    FlutterLogs.logToFile(
        logMessage: record.toString(),
        logFileName: _myLogFileName,
        overwrite: false,
        appendTimeStamp: true);
  }
}

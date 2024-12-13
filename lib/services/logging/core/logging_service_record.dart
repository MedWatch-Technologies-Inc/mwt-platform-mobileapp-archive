import 'dart:async';

import 'logging_levels.dart';

/// A log entry representation used to propagate information from [Logger] to
/// individual handlers.
class LoggingServiceRecord {
  final LoggingLevels level;
  final String message;

  /// Non-string message passed to Logger.
  final Object? object;

  /// Logger where this record is stored.
  final String loggerName;

  /// Time when this record was created.
  final DateTime time;

  /// Unique sequence number greater than all log records created before it.
  final int sequenceNumber;

  static int _nextNumber = 0;

  /// Associated error (if any) when recording errors messages.
  final Object? error;

  /// Associated stackTrace (if any) when recording errors messages.
  final StackTrace? stackTrace;

  /// Zone of the calling code which resulted in this LogRecord.
  final Zone? zone;

  final String? className;

  final String? methodName;

  LoggingServiceRecord(this.level, this.message, this.loggerName,
  {this.className, this.methodName, this.error, this.stackTrace, this.zone, this.object})
      : time = DateTime.now(),
        sequenceNumber = LoggingServiceRecord._nextNumber++;

  @override
  String toString() => '[${level.name}] ${getMap().toString()}';

  Map<String,dynamic> getMap(){
    return {
      'featureName': loggerName,
      'message': message,
      'className': className,
      'methodName': methodName,
      'error': error?.toString(),
      'stackTrace': stackTrace?.toString(),
      'timeStamp': time,
      'liveSessionSequenceNumber':sequenceNumber,
      'loggingLevel':level.name
    };
  }
}

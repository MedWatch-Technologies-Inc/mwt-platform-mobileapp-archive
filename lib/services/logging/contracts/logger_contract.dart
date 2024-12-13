import 'package:health_gauge/services/logging/core/logging_service_record.dart';

abstract class LoggerContract {
  Future<void> init();

  void setUserInfo(String? id);

  void unSetUserInfo();

  void log(LoggingServiceRecord record);
}

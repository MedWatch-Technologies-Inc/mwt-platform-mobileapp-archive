import '../logging/logging_service.dart';

class AppInitLogs {
  AppInitLogs._privateConstructor();

  static final AppInitLogs instance = AppInitLogs._privateConstructor();
  int count = 0;

  void log(String checkPoint) {
    count++;
    LoggingService().printLog(
        tag: 'AppInitLogs', message: '$checkPoint-$count: ${DateTime.now().millisecondsSinceEpoch}-${DateTime.now().second}-${DateTime.now().millisecond}');
  }
}

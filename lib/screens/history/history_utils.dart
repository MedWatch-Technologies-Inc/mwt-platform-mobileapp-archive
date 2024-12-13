import 'package:health_gauge/utils/gloabals.dart';

enum HistoryItemType { HeartRate, Oxygen, Temperature, BloodPressure }

String unitFromHistoryType(HistoryItemType? historyItemType) {
  if (historyItemType == null) {
    return 'N/A';
  }
  switch (historyItemType) {
    case HistoryItemType.HeartRate:
      return 'bpm';
    case HistoryItemType.Oxygen:
      return '%';
    case HistoryItemType.Temperature:
      if (tempUnit == 1) {
        return '°F';
      }
      return '°C';
    case HistoryItemType.BloodPressure:
      return 'mmHg';
  }
}

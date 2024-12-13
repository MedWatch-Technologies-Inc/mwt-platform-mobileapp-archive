import 'dart:io';

class HrMonitorModel {
  DateTime? dateTime;
  num? heartRate;

  HrMonitorModel.fromMap(map) {
    if(Platform.isAndroid) {
      if (map['heartStartTime'] is num) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(map['heartStartTime']);
      }
    } else {
      if (map['heartStartTime'] is String) {
        dateTime = DateTime.tryParse(map['heartStartTime']);
      }
    }
    if (map['heartValue'] is num) {
      heartRate = map['heartValue'];
    }
  }
}

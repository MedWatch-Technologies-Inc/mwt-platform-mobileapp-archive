class SleepReminderModel {
  String? startTime;
  List? daysList;
  String? userId;
  bool? isEnable;

  SleepReminderModel( {this.startTime, this.daysList, this.userId, this.isEnable});

  SleepReminderModel.fromMap(Map map) {
    try {
      if (map['startTime'] is String) {
        startTime = map['startTime'];
      }
    } catch (e) {
      print('Exception at startTime $e');
    }
    try {
      if (map['daysList'] is List) {
        daysList = map['daysList'];
      }
    } catch (e) {
      print('Exception at daysList $e');
    }
    try {
      if (map['userId'] is String) {
        userId = map['userId'];
      }
    } catch (e) {
      print('Exception at userId $e at ');
    }
    try {
      if (map['isEnable'] is bool) {
        isEnable = map['isEnable'];
      }
    } catch (e) {
      print('Exception at isEnable $e');
    }
  }

  Map toMap() {
    return {
      'startTime': startTime,
      'daysList': daysList,
      'userId': userId,
      'isEnable': isEnable,
    };
  }
}

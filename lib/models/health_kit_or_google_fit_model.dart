
import 'package:health_gauge/utils/date_utils.dart';
import 'package:intl/intl.dart';

class HealthKitOrGoogleFitModel {
  int? id;
  String? userId;
  String? typeName;
  var value;
  DateTime? startTime;
  DateTime? endTime;
  String? valueId;
  // String source;
  int? isSync;


  HealthKitOrGoogleFitModel({
    this.startTime,
    this.endTime,
    this.typeName,
    this.value,
    this.valueId
  });

  HealthKitOrGoogleFitModel.fromMap(Map map) {
    try {
      if (map['startTime'] is String) {
        startTime = DateFormat(DateUtil.yyyyMMddHHmmss).parse(map['startTime']);
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    try {
      if (map['endTime'] is String) {
        endTime = DateFormat(DateUtil.yyyyMMddHHmmss).parse(map['endTime']);
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    try {
      if (map['id'] is num) {
        id = map['id'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    try {
      if (map['user_Id'] is String) {
        userId = map['user_Id'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    try {
      if (map['typeName'] is String) {
        typeName = map['typeName'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }
    try {
      if (map['value'] != null ) {
        value = num.parse('${map['value']}').toDouble();
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }
    try {
      if (map['valueId'] is String) {
        valueId = map['valueId'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    try {
      if (map['isSync'] is num) {
        isSync = map['isSync'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    // try {
    //   if (check("source", map)) {
    //     source = map["source"];
    //   }
    // } catch (e) {
    //   print(e);
    // }

  }


  HealthKitOrGoogleFitModel.fromMapForLocalDataBase(Map map) {
    try {
      if (map['startTime'] is String) {
        startTime = DateFormat(DateUtil.yyyyMMddHHmmss).parse(map['startTime']);
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    try {
      if (map['endTime'] is String) {
        endTime = DateFormat(DateUtil.yyyyMMddHHmmss).parse(map['endTime']);
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    try {
      if (map['id'] is num) {
        id = map['id'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    try {
      if (map['user_Id'] is String) {
        userId = map['user_Id'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    try {
      if (map['typeName'] is String) {
        typeName = map['typeName'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }
    try {
      if (map['value'] is num) {
        value = map['value'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }
    try {
      if (map['valueId'] is String) {
        valueId = map['valueId'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    try {
      if (map['isSync'] is num) {
        isSync = map['isSync'];
      }
    } catch (e) {
      print('exception at HealthKitOrGoogleFitModel $e');
    }

    // try {
    //   if (check("source", map)) {
    //     source = map["source"];
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }

  Map<String,dynamic> toMap() {
    return {
      'userId':userId,
      'typeName':typeName,
      'value':value??0.0,
      'startTime':startTime,
      'endTime': endTime,
      'valueId':valueId,
      'isSync':isSync,
    };
  }

  Map<String,dynamic> toJson(String startDate , String endDate) {
    return {
      'userId':userId,
      'typeName':typeName,
      'value':value??0.0,
      'startTime':startDate,
      'endTime': endDate,
      'valueId':valueId,
      'isSync':isSync,
    };
  }
}
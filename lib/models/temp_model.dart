import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';

class TempModel {
  num? idForApi;
  num? id;
  num? oxygen;
  num? HRV;
  num? cvrrValue;
  num? tempDouble;
  num? tempInt;
  num? heartValue;
  num? stepValue;
  num? DBPValue;
  num? startTime;
  num? SBPValue;
  num? respiratoryRateValue;
  String? date;
  num? temperature;

  bool showHr = false;
  Object? realTemp;

  TempModel({
    this.oxygen,
    this.HRV,
    this.cvrrValue,
    this.tempDouble,
    this.tempInt,
    this.heartValue,
    this.stepValue,
    this.DBPValue,
    this.startTime,
    this.SBPValue,
    this.respiratoryRateValue,
    this.date,
    this.temperature,
  });

  TempModel.clone(TempModel model) {
    this.oxygen = model.oxygen;
    this.HRV = model.HRV;
    this.cvrrValue = model.cvrrValue;
    this.tempDouble = model.tempDouble;
    this.tempInt = model.tempInt;
    this.heartValue = model.heartValue;
    this.stepValue = model.stepValue;
    this.DBPValue = model.DBPValue;
    this.startTime = model.startTime;
    this.SBPValue = model.SBPValue;
    this.respiratoryRateValue = model.respiratoryRateValue;
    this.date = model.date;
    this.temperature = model.temperature;
  }

  TempModel.fromMap(Map map) {
    if (check('oxygen', map)) {
      oxygen = map['oxygen'];
    }
    if (check('HRV', map)) {
      HRV = map['HRV'];
    }
    if (check('cvrrValue', map)) {
      cvrrValue = map['cvrrValue'];
    }
    if (check('tempInt', map)) {
      tempInt = map['tempInt'];
    }
    if (check('tempDouble', map)) {
      tempDouble = map['tempDouble'];
      temperature = tempInt ?? 0 + (tempDouble ?? 0 / 100);
    }
    if (check('heartValue', map)) {
      heartValue = map['heartValue'];
    }
    if (check('stepValue', map)) {
      stepValue = map['stepValue'];
    }
    if (check('DBPValue', map)) {
      DBPValue = map['DBPValue'];
    }
    if (check('startTime', map)) {
      startTime = map['startTime'];
    }
    if (check('SBPValue', map)) {
      SBPValue = map['SBPValue'];
    }
    if (check('respiratoryRateValue', map)) {
      respiratoryRateValue = map['respiratoryRateValue'];
    }
    if (check('date', map)) {
      date = map['date'];
    }

    if (check('Temperature', map)) {
      temperature = map['Temperature'];
    }
  }

  TempModel.fromMapForAPI(Map map) {
    if (check('StatusID', map)) {
      idForApi = map['StatusID'];
    }
    if (check('Temperature', map)) {
      temperature = map['Temperature'];
    }
    if (check('Oxygen', map)) {
      oxygen = map['Oxygen'];
    }
    if (check('CVRR', map)) {
      cvrrValue = map['CVRR'];
    }
    if (check('HRV', map)) {
      HRV = map['HRV'];
    }
    if (check('HeartRate', map)) {
      heartValue = map['HeartRate'];
    }

    if (check('CreatedDateTime', map)) {
      date = map['CreatedDateTime'];
    }
  }

  TempModel.fromJson(Map map) {
    if (check('StatusID', map)) {
      idForApi = map['StatusID'];
    }
    if (check('Temperature', map)) {
      temperature = map['Temperature'];
    }
    if (check('Oxygen', map)) {
      oxygen = map['Oxygen'];
    }
    if (check('CVRR', map)) {
      cvrrValue = map['CVRR'];
    }
    if (check('HRV', map)) {
      HRV = map['HRV'];
    }
    if (check('HeartRate', map)) {
      heartValue = map['HeartRate'];
    }

    if (check('CreatedDateTime', map)) {
      date = map['CreatedDateTime'];
    }
  }

  TempModel.fromMapForDb(Map map) {
    if (map['id'] is int) {
      id = map['id'];
    }
    if (map['HRV'] is num) {
      HRV = map['HRV'];
    }
    if (map['HeartRate'] is num) {
      heartValue = map['HeartRate'];
    }
    if (map['Temperature'] is num) {
      temperature = map['Temperature'];
    }
    if (map['date'] is String) {
      date = map['date'];
    }
    if (map['CVRR'] is num) {
      cvrrValue = map['CVRR'];
    }
    if (map['Oxygen'] is num) {
      oxygen = map['Oxygen'];
    }
    if (map['IdForApi'] is num) {
      idForApi = map['IdForApi'];
    }
  }

  Map<String, dynamic> toMap() {
    try {
      if (date?.isNotEmpty ?? false) {
        final DateFormat formatter = DateFormat(DateUtil.yyyyMMddHHmmss);
        date = formatter.format(DateTime.parse(date!));
      }
    } catch (e) {
      print('Exception at toMap $e');
    }
    if (tempInt == null && temperature != null) {
      var list = temperature?.toString().split('.');
      if ((list?.length ?? 0) >= 2) {
        tempInt = num.parse(list!.first);
        tempDouble = num.parse(list.first);
      }
    }
    return {
      'HRV': HRV,
      'HeartRate': heartValue,
      'Temperature': num.parse('$tempInt.$tempDouble'),
      'date': date,
      'CVRR': cvrrValue,
      'Oxygen': oxygen,
      'IdForApi': idForApi?.toInt(),
    };
  }

  Map<String, dynamic> toMapForAPI() {
    try {
      if (date?.isNotEmpty ?? false) {
        final DateFormat formatter = DateFormat(DateUtil.yyyyMMddHHmmss);
        date = formatter.format(DateTime.parse(date!));
      }
    } catch (e) {
      print('Exception at toMap $e');
    }
    // here lies the problem if temperature value is present then this line will change it to 0.0;
    // there for while sending api request for saving user data this temperature will be 0
    if (tempInt != null && tempDouble != null) {
      temperature = num.parse('${tempInt ?? 0}.${tempDouble ?? 0}');
    }
    temperature ??= 0.0;
    var dateTime = DateTime.now();
    if(date!=null && date!.isNotEmpty){
      dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date!);
    }
    return {
      'FKUserID': preferences!.getString(Constants.prefUserIdKeyInt),
      'Temperature': num.parse('$temperature'),
      'HRV': HRV,
      'HeartRate': heartValue,
      'CreatedDateTime': date,
      'CVRR': cvrrValue,
      'Oxygen': oxygen,
      'CreatedDateTimeStamp': dateTime.millisecondsSinceEpoch.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    try {
      if (date?.isNotEmpty ?? false) {
        final DateFormat formatter = DateFormat(DateUtil.yyyyMMddHHmm);
        date = formatter.format(DateTime.parse(date!));
      }
    } catch (e) {
      print('Exception at toMap $e');
    }
    temperature = num.parse('${tempInt ?? 0}.${tempDouble ?? 0}');
    return {
      'FKUserID': preferences!.getString(Constants.prefUserIdKeyInt),
      'Temperature': num.parse('$temperature'),
      'HRV': HRV,
      'HeartRate': heartValue,
      'CreatedDateTime': date,
      'CVRR': cvrrValue,
      'Oxygen': oxygen,
    };
  }

  bool check(String key, Map map) {
    if (map[key] != null) {
      if (map[key] is String && map[key] == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }
}

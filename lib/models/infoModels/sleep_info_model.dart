import 'dart:convert';
import 'dart:io';

import 'package:health_gauge/utils/constants.dart';

class SleepInfoModel {
  int? id;
  int? isSync;
  String? date;
  int sleepAllTime = 0;

  int deepTime = 0;
  int lightTime = 0;
  int stayUpTime = 0;
  int wakInCount = 0;
  int? idForApi;

  int allTime = 0;

  int? sdkType = -1;

  List<SleepDataInfoModel> data = <SleepDataInfoModel>[];

  String? createDateTimeStamp;

  SleepInfoModel.clone(SleepInfoModel model) {
    date = model.date;
    sleepAllTime = model.sleepAllTime;
    deepTime = model.deepTime;
    lightTime = model.lightTime;
    stayUpTime = model.stayUpTime;
    wakInCount = model.wakInCount;
    allTime = model.allTime;
    data = model.data.map((e) => SleepDataInfoModel.clone(e)).toList();
    idForApi = model.idForApi;
    createDateTimeStamp = model.createDateTimeStamp;
  }

  SleepInfoModel({
    this.date,
    required this.sleepAllTime,
    required this.deepTime,
    required this.lightTime,
    required this.stayUpTime,
    required this.wakInCount,
    required this.allTime,
    required this.data,
    this.idForApi,
    this.createDateTimeStamp,
  });

  SleepInfoModel.fromMap(Map map) {
    if (check('id', map)) {
      id = map['id'];
    }
    if (check('IdForApi', map)) {
      idForApi = map['IdForApi'];
    }
    if (check('IsSync', map)) {
      isSync = map['IsSync'];
    }
    if (check('date', map)) {
      date = map['date'];
    }
    if (check('sdkType', map)) {
      sdkType = map['sdkType'];
    }
    if (check('sleepAllTime', map)) {
      if (map['sleepAllTime'] is String) {
        sleepAllTime = int.parse(map['sleepAllTime']);
      } else {
        sleepAllTime = map['sleepAllTime'];
      }
    }
    if (check('deepTime', map)) {
      if (map['deepTime'] is String) {
        deepTime = int.parse(map['deepTime']);
      } else {
        deepTime = map['deepTime'];
      }
    }
    if (check('lightTime', map)) {
      if (map['lightTime'] is String) {
        lightTime = int.parse(map['lightTime']);
      } else {
        lightTime = map['lightTime'];
      }
    }
    if (check('stayUpTime', map)) {
      if (map['stayUpTime'] is String) {
        stayUpTime = int.parse(map['stayUpTime']);
      } else {
        stayUpTime = map['stayUpTime'];
      }
    }
    if (check('wakInCount', map)) {
      if (map['wakInCount'] is String) {
        wakInCount = int.parse(map['wakInCount']);
      } else {
        wakInCount = map['wakInCount'];
      }
    }
    if (check('allTime', map)) {
      if (map['allTime'] is String) {
        allTime = int.parse(map['allTime']);
      } else {
        allTime = map['allTime'];
      }
    }
    if (check('data', map)) {
      List list;
      if (map['data'] is String && map['data'].isNotEmpty) {
        list = map['data'].split('*');
        data =
            list.map((e) => SleepDataInfoModel.fromMap(jsonDecode(e))).toList();
      } else if (map['data'] is List) {
        list = map['data'];
        data = list.map((e) => SleepDataInfoModel.fromMap(e)).toList();
      }
    }
    if (check('typeDate', map)) {
      List list = map['typeDate'];
      data = list.map((e) => SleepDataInfoModel.fromMap(e)).toList();
    }

    if (check('ID', map)) {
      idForApi = map['ID'];
    }
    if (check('CreateDateTimeStamp', map)) {
      try {
        date = DateTime.parse(map['CreateDateTimeStamp']).toString();
      } catch (e) {
        print(e);
      }
    }
    if (check('sleepTotalTime', map)) {
      allTime = double.parse(map['sleepTotalTime'].toString()).toInt();
    }
    if (check('sleepTotalTime', map)) {
      sleepAllTime = double.parse(map['sleepTotalTime'].toString()).toInt();
    }
    if (check('sleepDeepTime', map)) {
      deepTime = double.parse(map['sleepDeepTime'].toString()).toInt();
    }
    if (check('sleepLightTime', map)) {
      lightTime = double.parse(map['sleepLightTime'].toString()).toInt();
    }
    if (check('sleepStayupTime', map)) {
      stayUpTime = double.parse(map['sleepStayupTime'].toString()).toInt();
    }
    if (check('sleepWalkingNumber', map)) {
      wakInCount = double.parse(map['sleepWalkingNumber'].toString()).toInt();
    }

    if (check('SleepData', map)) {
      List list = map['SleepData'];
      data = list.map((t) => SleepDataInfoModel.fromMap(t)).toList();
    }
    if (check('CreateDateTimeStamp', map)) {
      try {
        createDateTimeStamp = map['CreateDateTimeStamp'];
      } catch (e) {
        print(e);
      }
    }

    if (Platform.isIOS && sdkType != Constants.e66 && sdkType != -1) {
      stayUpTime = 0;
      deepTime = 0;
      lightTime = 0;

      if (data.length > 0) {
        for (var i = 0; i < data.length; i++) {
          if (i == data.length - 1) {
            break;
          }
          var model = data[i];
          var nextModel = data[i + 1];

          var nowHour = int.tryParse(model.time?.split(':')[0] ?? '') ?? 0;
          var nowMinute = int.tryParse(model.time?.split(':')[1] ?? '') ?? 0;

          var nextHour = int.tryParse(nextModel.time?.split(':')[0] ?? '') ?? 0;
          var nextMinute =
              int.tryParse(nextModel.time?.split(':')[1] ?? '') ?? 0;

          var current = DateTime.now();

          var nowDateTime = DateTime(current.year, current.month,
              nowHour > 12 ? current.day - 1 : current.day, nowHour, nowMinute);
          var nextDateTime = DateTime(
              current.year,
              current.month,
              nextHour > 12 ? current.day - 1 : current.day,
              nextHour,
              nextMinute);

          var minutes = nextDateTime.difference(nowDateTime).inMinutes;
          switch (model.type) {
            case '0': //stay up all night
              stayUpTime += minutes;
              break;
            case '1': //sleep
              allTime += minutes;
              break;
            case '2': //light sleep
              lightTime += minutes;
              break;
            case '3': //deep sleep
              deepTime += minutes;
              break;
            case '4': //wake up half
              wakInCount += minutes;
              break;
            case '5': //wake up
              wakInCount += minutes;
              break;
          }
        }
      }
    }
  }

  SleepInfoModel.fromJson(Map map) {
    if (check('id', map)) {
      id = map['id'];
    }
    if (check('IdForApi', map)) {
      idForApi = map['IdForApi'];
    }
    if (check('IsSync', map)) {
      isSync = map['IsSync'];
    }
    if (check('date', map)) {
      date = map['date'];
    }
    if (check('sdkType', map)) {
      sdkType = map['sdkType'];
    }
    if (check('sleepAllTime', map)) {
      if (map['sleepAllTime'] is String) {
        sleepAllTime = int.parse(map['sleepAllTime']);
      } else {
        sleepAllTime = map['sleepAllTime'];
      }
    }
    if (check('deepTime', map)) {
      if (map['deepTime'] is String) {
        deepTime = int.parse(map['deepTime']);
      } else {
        deepTime = map['deepTime'];
      }
    }
    if (check('lightTime', map)) {
      if (map['lightTime'] is String) {
        lightTime = int.parse(map['lightTime']);
      } else {
        lightTime = map['lightTime'];
      }
    }
    if (check('stayUpTime', map)) {
      if (map['stayUpTime'] is String) {
        stayUpTime = int.parse(map['stayUpTime']);
      } else {
        stayUpTime = map['stayUpTime'];
      }
    }
    if (check('wakInCount', map)) {
      if (map['wakInCount'] is String) {
        wakInCount = int.parse(map['wakInCount']);
      } else {
        wakInCount = map['wakInCount'];
      }
    }
    if (check('allTime', map)) {
      if (map['allTime'] is String) {
        allTime = int.parse(map['allTime']);
      } else {
        allTime = map['allTime'];
      }
    }
    if (check('data', map)) {
      List list;
      if (map['data'] is String && map['data'].isNotEmpty) {
        list = map['data'].split('*');
        data =
            list.map((e) => SleepDataInfoModel.fromMap(jsonDecode(e))).toList();
      } else if (map['data'] is List) {
        list = map['data'];
        data = list.map((e) => SleepDataInfoModel.fromMap(e)).toList();
      }
    }
    if (check('typeDate', map)) {
      List list = map['typeDate'];
      data = list.map((e) => SleepDataInfoModel.fromMap(e)).toList();
    }

    if (check('ID', map)) {
      idForApi = map['ID'];
    }
    if (check('CreateDateTimeStamp', map)) {
      try {
        var d = DateTime.tryParse(map['CreateDateTimeStamp']);
        if (d != null) {
          date = d.toString();
        } else {
          date = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(map['CreateDateTimeStamp']))
              .toString();
        }
      } catch (e) {
        print(e);
      }
    }
    if (check('CreatedDateTimeStamp', map)) {
      try {
        var d = DateTime.tryParse(map['CreatedDateTimeStamp']);
        if (d != null) {
          date = d.toString();
        } else {
          date = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(map['CreatedDateTimeStamp']))
              .toString();
        }
      } catch (e) {
        print(e);
      }
    }
    if (check('sleepTotalTime', map)) {
      allTime = double.parse(map['sleepTotalTime'].toString()).toInt();
    }
    if (check('sleepTotalTime', map)) {
      sleepAllTime = double.parse(map['sleepTotalTime'].toString()).toInt();
    }
    if (check('sleepDeepTime', map)) {
      deepTime = double.parse(map['sleepDeepTime'].toString()).toInt();
    }
    if (check('sleepLightTime', map)) {
      lightTime = double.parse(map['sleepLightTime'].toString()).toInt();
    }
    if (check('sleepStayupTime', map)) {
      stayUpTime = double.parse(map['sleepStayupTime'].toString()).toInt();
    }
    if (check('sleepWalkingNumber', map)) {
      wakInCount = double.parse(map['sleepWalkingNumber'].toString()).toInt();
    }

    if (check('SleepData', map)) {
      List list = map['SleepData'];
      data = list.map((t) => SleepDataInfoModel.fromMap(t)).toList();
    }

    if (check('CreateDateTimeStamp', map)) {
      try {
        createDateTimeStamp = map['CreateDateTimeStamp'];
      } catch (e) {
        print(e);
      }
    }

    if (check('CreatedDateTimeStamp', map)) {
      try {
        createDateTimeStamp = map['CreateDateTimeStamp'];
      } catch (e) {
        print(e);
      }
    }

    if (Platform.isIOS && sdkType != Constants.e66 && sdkType != -1) {
      stayUpTime = 0;
      deepTime = 0;
      lightTime = 0;

      if (data.length > 0) {
        for (var i = 0; i < data.length; i++) {
          if (i == data.length - 1) {
            break;
          }
          var model = data[i];
          var nextModel = data[i + 1];

          var nowHour = int.tryParse(model.time?.split(':')[0] ?? '') ?? 0;
          var nowMinute = int.tryParse(model.time?.split(':')[1] ?? '') ?? 0;

          var nextHour = int.tryParse(nextModel.time?.split(':')[0] ?? '') ?? 0;
          var nextMinute =
              int.tryParse(nextModel.time?.split(':')[1] ?? '') ?? 0;

          var current = DateTime.now();

          var nowDateTime = DateTime(current.year, current.month,
              nowHour > 12 ? current.day - 1 : current.day, nowHour, nowMinute);
          var nextDateTime = DateTime(
              current.year,
              current.month,
              nextHour > 12 ? current.day - 1 : current.day,
              nextHour,
              nextMinute);

          var minutes = nextDateTime.difference(nowDateTime).inMinutes;
          switch (model.type) {
            case '0': //stay up all night
              stayUpTime += minutes;
              break;
            case '1': //sleep
              allTime += minutes;
              break;
            case '2': //light sleep
              lightTime += minutes;
              break;
            case '3': //deep sleep
              deepTime += minutes;
              break;
            case '4': //wake up half
              wakInCount += minutes;
              break;
            case '5': //wake up
              wakInCount += minutes;
              break;
          }
        }
      }
    }
  }

  Map<String, dynamic> toMap() {
    var mapList = data.map((e) => jsonEncode(e.toMap())).toList();
    return {
      'date': date.toString(),
      'sleepAllTime': sleepAllTime.toString(),
      'deepTime': deepTime.toString(),
      'lightTime': lightTime.toString(),
      'stayUpTime': stayUpTime.toString(),
      'wakInCount': wakInCount.toString(),
      'allTime': allTime.toString(),
      'data': mapList.join('*'),
      'IdForApi': idForApi,
      'CreateDateTimeStamp': createDateTimeStamp,
    };
  }

  Map<String, dynamic> toJson() {
    var mapList = data.map((e) => jsonEncode(e.toMap())).toList();
    return {
      'date': date.toString(),
      'sleepAllTime': sleepAllTime.toString(),
      'deepTime': deepTime.toString(),
      'lightTime': lightTime.toString(),
      'stayUpTime': stayUpTime.toString(),
      'wakInCount': wakInCount.toString(),
      'allTime': allTime.toString(),
      'data': mapList.join('*'),
      'IdForApi': idForApi,
      'CreateDateTimeStamp': createDateTimeStamp
    };
  }

  Map<String, dynamic> toMapForApi() {
    return {
      'sleepDate': date,
      'sleepTotalTime': allTime,
      'sleepDeepTime': deepTime,
      'sleepLightTime': lightTime,
      'sleepStayupTime': stayUpTime,
      'sleepWalkingNumber': wakInCount,
      'sleepData': List.generate(data.length, (index) => data[index].toMap()),
      'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString()
    };
  }

  @override
  String toString() {
    return 'SleepInfoModel{date: $date, sleepAllTime: $sleepAllTime, deepTime: $deepTime, lightTime: $lightTime, stayUpTime: $stayUpTime, wakInCount: $wakInCount, allTime: $allTime, data: $data}';
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

class SleepDataInfoModel {
  String? type;
  String? time;
  DateTime? dateTime;

  SleepDataInfoModel({this.type, this.time, this.dateTime});

  SleepDataInfoModel.clone(SleepDataInfoModel model) {
    type = model.type;
    time = model.time;
    dateTime = model.dateTime;
  }

  SleepDataInfoModel.fromMap(Map map) {
    if (check('type', map)) {
      type = map['type'].toString();
    }
    if (check('sleep_type', map)) {
      type = map['sleep_type'].toString();
    }
    if (check('time', map)) {
      time = map['time'].toString();
    }
    if (check('startTime', map)) {
      time = map['startTime'];
    }
  }

  Map<String, dynamic> toMap() {
    return {'sleep_type': type, 'startTime': time};
  }

  @override
  String toString() {
    return 'SleepDataInfoModel{type: $type, time: $time}';
  }

  check(String key, Map map) {
    if (map[key] != null) {
      if (map[key] is String && map[key] == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }
}

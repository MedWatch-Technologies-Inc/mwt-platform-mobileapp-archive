class MotionInfoModel {
  int? id;
  String? date;
  num? calories;
  num? distance;
  int? step;
  List? data;
  int? isSync;
  int? idForApi;
  String? createdDateTimeStamp;

  MotionInfoModel({
    this.date,
    this.calories,
    this.distance,
    this.step,
    this.data,
    this.isSync,
    this.idForApi,
    this.createdDateTimeStamp,
  });

  MotionInfoModel.clone(MotionInfoModel model) {
    id = model.id;
    date = model.date;
    calories = model.calories;
    distance = model.distance;
    step = model.step;
    data = model.data;
    isSync = model.isSync;
    idForApi = model.idForApi;
    createdDateTimeStamp = model.createdDateTimeStamp;
  }

  MotionInfoModel.fromMap(Map map) {
    if (check('date', map)) {
      date = map['date'];
    }
    if (check("CreatedDateTime", map)) {
      try {
        date = DateTime.parse(map["CreatedDateTime"]).toString();
      } catch (e) {
        print(e);
      }
    }
    if (check('id', map)) {
      id = map['id'];
    }
    if (check('calories', map)) {
      calories = map['calories'];
    }
    if (check('distance', map)) {
      distance = map['distance'];
    }
    if (check('step', map)) {
      if (map['step'] is double) {
        step = map['step'].round();
      } else {
        step = map['step'];
      }
    }
    if (check('data', map) && map['data'] is List) {
      data = map['data'];
    }
    if (check('IsSync', map)) {
      isSync = map['IsSync'];
    }
    if (check('IdForApi', map)&& map['IdForApi'] is num) {
      idForApi = map['IdForApi'];
    }

    if (check('ID', map)) {
      idForApi = map['ID'];
    }
    if (check('Steps', map)) {
      step = map['Steps'];
    }
    if (check('KCal', map)) {
      calories = map['KCal'];
    }
    if (check('Mileage', map)) {
      distance = map['Mileage'];
    }
    try {
      if (check('Data', map) && map['Data'] is List) {
        data = map['Data'];
      }

      if (check('Data', map) && map['Data'] is String) {
        data = map['Data'].split(',').map((e) => int.parse(e)).toList();
      }
    } catch (e) {
      print(e);
    }
    try {
      if (check('data', map) && map['data'] is List) {
        data = map['data'];
      }

      if (check('data', map) && map['data'] is String) {
        data = map['data'].split(',').map((e) => int.parse(e)).toList();
      }
    } catch (e) {
      print(e);
    }
    try {
      if (check('CreatedDateTimeStamp', map)) {
        createdDateTimeStamp = map['CreatedDateTimeStamp'];
      }
    } catch (e) {
      print(e);
    }
  }

  MotionInfoModel.fromJson(Map map) {
    if (check('date', map)) {
      date = map['date'];
    }
    if (check("CreatedDateTime", map)) {
      try {
        date = DateTime.parse(map["CreatedDateTime"]).toString();
      } catch (e) {
        print(e);
      }
    }
    if (check('id', map)) {
      id = map['id'];
    }
    if (check('calories', map)) {
      calories = map['calories'];
    }
    if (check('distance', map)) {
      distance = map['distance'];
    }
    if (check('step', map)) {
      if (map['step'] is double) {
        step = map['step'].round();
      } else {
        step = map['step'];
      }
    }
    if (check('data', map) && map['data'] is List) {
      data = map['data'];
    }
    if (check('IsSync', map)) {
      isSync = map['IsSync'];
    }
    if (check('IdForApi', map)) {
      idForApi = map['IdForApi'];
    }

    if (check('ID', map)) {
      idForApi = map['ID'];
    }
    if (check('Steps', map)) {
      step = map['Steps'];
    }
    if (check('KCal', map)) {
      calories = map['KCal'];
    }
    if (check('Mileage', map)) {
      distance = map['Mileage'];
    }
    try {
      if (check('Data', map) && map['Data'] is List) {
        data = map['Data'];
      }

      if (check('Data', map) && map['Data'] is String) {
        data = map['Data'].split(',').map((e) => int.parse(e)).toList();
      }
    } catch (e) {
      print(e);
    }
    try {
      if (check('data', map) && map['data'] is List) {
        data = map['data'];
      }

      if (check('data', map) && map['data'] is String) {
        data = map['data'].split(',').map((e) => int.parse(e)).toList();
      }
    } catch (e) {
      print(e);
    }

    try {
      if (check('CreatedDateTimeStamp', map)) {
        createdDateTimeStamp = map['CreatedDateTimeStamp'];
        date = DateTime.fromMillisecondsSinceEpoch(
                int.parse(createdDateTimeStamp!))
            .toString();
      }
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'calories': calories,
      'distance': distance,
      'step': step,
      'data': data?.join(','),
      'IdForApi': idForApi,
      'CreatedDateTimeStamp': createdDateTimeStamp
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'calories': calories,
      'distance': distance,
      'step': step,
      'data': data?.join(','),
      'IdForApi': idForApi,
      'CreatedDateTimeStamp': createdDateTimeStamp
    };
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

  @override
  String toString() {
    return 'MotionInfoModel{date: $date, calories: $calories, distance: $distance, step: $step, data: $data}';
  }
}

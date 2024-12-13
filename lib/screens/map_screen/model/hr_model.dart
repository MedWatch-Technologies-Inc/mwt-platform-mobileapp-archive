class HeartRateModel {
  int? id;
  int? isSync;
  int? sbp;
  int? dbp;
  int? hr;
  int? hrv;
  int? hour;
  String? date;
  List<String>? ecg;
  List<String>? ppg;

  int? tSbp;
  int? tDbp;
  int? tHr;

  int? aiSBP;
  int? aiDbp;

  int? idForApi = 0;

  bool? isCalibration = false;
  bool? isForHourlyHR = false;
  bool? isForTimeBasedPpg = false;

  var isFromCamera;
  String? deviceType = "";

  HeartRateModel();

  HeartRateModel.fromMap(Map map) {
    if (check("IdForApi", map)) {
      idForApi = map["IdForApi"];
    }
    if (check("isFromCamera", map)) {
      isFromCamera = map["isFromCamera"] == 1;
    }
    if (check("tHr", map)) {
      tHr = map["tHr"];
    }
    if (check("tSBP", map)) {
      tSbp = map["tSBP"];
    }
    if (check("tDBP", map)) {
      tDbp = map["tDBP"];
    }
    if (check("id", map)) {
      id = map["id"];
    }
    if (check("IsSync", map)) {
      isSync = map["IsSync"];
    }
    if (check("approxSBP", map)) {
      sbp = map["approxSBP"];
    }
    if (check("approxDBP", map)) {
      dbp = map["approxDBP"];
    }
    if (check("approxHr", map)) {
      hr = map["approxHr"];
    }
    if (check("hrv", map)) {
      hrv = map["hrv"];
    }
    if (check("hour", map)) {
      hour = map["hour"];
    }
    if (check("date", map)) {
      date = map["date"];
    }
    if (check("ecg", map)) {
      String strEcg = map["ecg"].toString();
      ecg = strEcg.split(",");
    }
    if (check("ppg", map)) {
      String strPpg = map["ppg"].toString();
      ppg = strPpg.split(",");
    }

    if (check("DeviceType", map)) {
      deviceType = map["DeviceType"];
    }

    if (check("ID", map)) {
      idForApi = map["ID"];
    }
    if (check("data", map)) {
      Map data = map["data"][0];
      if (check("raw_ecg", data)) {
        List rawEcg = data["raw_ecg"];
        ecg = rawEcg.map((f) => f.toString()).toList();
      }
      if (check("raw_ppg", data)) {
        List rawPpg = data["raw_ppg"];
        ppg = rawPpg.map((f) => f.toString()).toList();
      }

      if (check("sys_manual", data)) {
        tSbp = double.parse(data["sys_manual"].toString()).toInt();
      }
      if (check("dias_manual", data)) {
        tDbp = double.parse(data["dias_manual"].toString()).toInt();
      }
      if (check("hr_manual", data)) {
        tHr = double.parse(data["hr_manual"].toString()).toInt();
      }

      if (check("dias_healthgauge", data)) {
        aiDbp = double.parse(data["dias_healthgauge"].toString()).toInt();
      }
      if (check("sys_healthgauge", data)) {
        aiSBP = double.parse(data["sys_healthgauge"].toString()).toInt();
      }

      if (check("dias_device", data)) {
        dbp = double.parse(data["dias_device"].toString()).toInt();
      }
      if (check("sys_device", data)) {
        sbp = double.parse(data["sys_device"].toString()).toInt();
      }
      if (check("hr_device", data)) {
        hr = double.parse(data["hr_device"].toString()).toInt();
      }
      if (check("hrv_device", data)) {
        hrv = double.parse(data["hrv_device"].toString()).toInt();
      }
      if (check("device_type", data)) {
        deviceType = data["device_type"];
      }

      if (check("timestamp", data)) {
        try {
          int timestamp = int.parse(data["timestamp"].toString());
          date = DateTime.fromMillisecondsSinceEpoch(timestamp).toString();
        } catch (e) {
          print(e);
        }
      }
    }

    if (check("isForHourlyHR", map)) {
      isForHourlyHR = map["isForHourlyHR"] == 1;
    }

    if (check("isForTimeBasedPpg", map)) {
      isForTimeBasedPpg = map["isForTimeBasedPpg"] == 1;
    }

    if (check("IsCalibration", map)) {
      isCalibration = map["IsCalibration"] == 1;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "IdForApi": idForApi,
      "date": date,
      "ecg": ecg != null ? ecg!.join(",") : "",
      "ppg": ppg != null ? ppg!.join(",") : "",
      "tHr": tHr,
      "tSBP": tSbp,
      "tDBP": tDbp,
      "approxSBP": sbp,
      "approxDBP": dbp,
      "approxHr": hr,
      "hrv": hrv,
      "aiSBP": aiSBP,
      "aiDBP": aiDbp,
      "IsCalibration": isCalibration ?? false,
      "isFromCamera": isFromCamera ?? false,
    };
  }

  check(String key, Map map) {
    if (map != null && map.containsKey(key) && map[key] != null) {
      if (map[key] is String && map[key] == "null") {
        return false;
      }
      return true;
    }
    return false;
  }

  HeartRateModel.clone(HeartRateModel measurementHistoryItem) {
    id = measurementHistoryItem.id;
    isSync = measurementHistoryItem.isSync;
    sbp = measurementHistoryItem.sbp;
    dbp = measurementHistoryItem.dbp;
    hr = measurementHistoryItem.hr;
    hrv = measurementHistoryItem.hrv;
    hour = measurementHistoryItem.hour;
    date = measurementHistoryItem.date;
    ecg = measurementHistoryItem.ecg;
    ppg = measurementHistoryItem.ppg;
    tSbp = measurementHistoryItem.tSbp;
    tDbp = measurementHistoryItem.tDbp;
    tHr = measurementHistoryItem.tHr;
    idForApi = measurementHistoryItem.idForApi;
    isForHourlyHR = measurementHistoryItem.isForHourlyHR;
    isForTimeBasedPpg = measurementHistoryItem.isForTimeBasedPpg;
    deviceType = measurementHistoryItem.deviceType;
  }
}

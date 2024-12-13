class MeasurementHistoryModel {
  int?  id;
  int? isSync;
  int? sbp;
  int? dbp;
  int? hr;
  int? hrv;
  int? BG;
  int? Uncertainty;
  int? BG1;
  String? Unit;
  String? Unit1;
  String? Class;
  int? hour;
  String? date;
  String? hrDate;
  List<String>? ecg;
  List<String>? ppg;
  List<String>? hrvs;

  int? tSbp;
  int? tDbp;
  int? tHr;

  int? aiSBP;
  int? aiDbp;

  int? idForApi = 0;

  bool? isFromCamera;
  bool? isForTimeBasedPpg = false;
  bool? isCalibration = false;
  bool? isForHourlyHR = false;
  bool? isForOscillometric = false;

  String? deviceType = '';


  MeasurementHistoryModel({
      this.id,
      this.isSync,
      this.sbp,
      this.dbp,
      this.hr,
      this.hrv,
      this.BG,
      this.Uncertainty, 
      this.BG1,
      this.Unit,
      this.Unit1,
      this.Class,
      this.hour,
      this.date,
      this.ecg,
      this.ppg,
      this.hrvs,
      this.tSbp,
      this.tDbp,
      this.tHr,
      this.aiSBP,
      this.aiDbp,
      this.idForApi,
      this.isCalibration,
      this.isForOscillometric,
      this.isForHourlyHR,
      this.isForTimeBasedPpg,
      this.isFromCamera,
      this.deviceType,
    this.hrDate,
  });

  MeasurementHistoryModel.fromMap(Map map) {
    if (check('IdForApi', map)) {
      idForApi = map['IdForApi'];
    }
    if (check('tHr', map)) {
      tHr = map['tHr'];
    }
    if (check('tSBP', map)) {
      tSbp = map['tSBP'];
    }
    if (check('tDBP', map)) {
      tDbp = map['tDBP'];
    }
    if (check('id', map)) {
      id = map['id'];
    }
    if (check('IsSync', map)) {
      isSync = map['IsSync'];
    }
    if (check('approxSBP', map)) {
      sbp = map['approxSBP'];
    }
    if (check('approxDBP', map)) {
      dbp = map['approxDBP'];
    }
    if (check('approxHr', map)) {
      hr = map['approxHr'].toInt();
    }
    if (map['hrv'] is num) {
      hrv = (map['hrv']).toInt();
    }
    if (check('BG', map)) {
      BG = double.parse(map['BG'].toString()).toInt();
    }
    if (check('Uncertainty', map)) {
      Uncertainty = double.parse(map['Uncertainty'].toString()).toInt();
    }

    if (check('BG1', map)) {
      BG1 = double.parse(map['BG1'].toString()).toInt();
    }

    if (check('Unit', map)) {
      Unit = map['Unit'];
    } 
    
    if (check('Unit1', map)) {
      Unit1 = map['Unit1'];
    } 
    
    if (check('Class', map)) {
      Class = map['Class'];
    }
    
    if (check('hour', map)) {
      hour = map['hour'];
    }
    if (check('date', map)) {
      date = map['date'];
    }
    if (check('ecg', map)) {
      String strEcg = map['ecg'].toString();
      ecg = strEcg.split(',');
    }
    if (check('ppg', map)) {
      String strPpg = map['ppg'].toString();
      ppg = strPpg.split(',');
    }
    if (check('hrvs', map)) {
      String strhrvs = map['hrvs'].toString();
      hrvs = strhrvs.split(',');
    }

    if (check('DeviceType', map)) {
      deviceType = map['DeviceType'];
    }

    if (check('ID', map)) {
      idForApi = map['ID'];
    }
    if (check('data', map)) {
      Map data = map['data'][0];
      if (check('raw_ecg', data)) {
        List rawEcg = data['raw_ecg'];
        ecg = rawEcg.map((f) => f.toString()).toList();
      }
      if (check('raw_ppg', data)) {
        List rawPpg = data['raw_ppg'];
        ppg = rawPpg.map((f) => f.toString()).toList();
      }
      if (check('raw_hrv', data)) {
        List rawPpg = data['raw_hrv'];
        hrvs = rawPpg.map((f) => f.toString()).toList();
      }
    }
      if (check('sys_manual', map)) {
        tSbp = double.parse(map['sys_manual'].toString()).toInt();
      }
      if (check('dias_manual', map)) {
        tDbp = double.parse(map['dias_manual'].toString()).toInt();
      }
      if (check('hr_manual', map)) {
        tHr = double.parse(map['hr_manual'].toString()).toInt();
      }

      if (check('dias_healthgauge', map)) {
        aiDbp = double.parse(map['dias_healthgauge'].toString()).toInt();
      }
      if (check('aiDBP', map)) {
        aiDbp = double.parse(map['aiDBP'].toString()).toInt();
      }
      if (check('sys_healthgauge', map)) {
        aiSBP = double.parse(map['sys_healthgauge'].toString()).toInt();
      }
      if (check('aiSBP', map)) {
        aiSBP = double.parse(map['aiSBP'].toString()).toInt();
      }

      if (check('dias_device', map)) {
        dbp = double.parse(map['dias_device'].toString()).toInt();
      }
      if (check('sys_device', map)) {
        sbp = double.parse(map['sys_device'].toString()).toInt();
      }
      if (check('hr_device', map)) {
        hr = double.parse(map['hr_device'].toString()).toInt();
      }
      if (check('hrv_device', map)) {
        hrv = double.parse(map['hrv_device'].toString()).toInt();
      }
      if (check('device_type', map)) {
        deviceType = map['device_type'];
      }

      if (check('timestamp', map)) {
        try {
          int timestamp = int.parse(map['timestamp'].toString());
          date = DateTime.fromMillisecondsSinceEpoch(timestamp).toString();
        } catch (e) {
          print(e);
        }
      }

      if(map['isForOscillometric'] is int){
        isForOscillometric = getBoolFromInt(map['isForOscillometric']);
      }
      if(map['isForOscillometric'] is bool){
        isForOscillometric = map['isForOscillometric'];
      }



    if (map['isFromCamera'] is int) {
      isFromCamera =getBoolFromInt(map['isFromCamera']);
    }
    if (map['isFromCamera'] is bool) {
      isFromCamera = map['isFromCamera'];
    }


    if (map['isForHourlyHR'] is int) {
      isForHourlyHR =getBoolFromInt(map['isForHourlyHR']);
    }
    if (map['isForHourlyHR'] is bool) {
      isForHourlyHR = map['isForHourlyHR'];
    }

    if (map['isForTimeBasedPpg'] is int) {
      isForTimeBasedPpg = getBoolFromInt(map['isForTimeBasedPpg']);
    }
    if (map['isForTimeBasedPpg'] is bool) {
      isForTimeBasedPpg = map['isForTimeBasedPpg'];
    }

    if (map['IsCalibration'] is int) {
      isCalibration = getBoolFromInt(map['IsCalibration']);
    }
    if (map['IsCalibration'] is bool) {
      isCalibration = map['IsCalibration'];
    }
  }

  MeasurementHistoryModel.fromJson(Map map) {

    if (check('IdForApi', map)) {
      idForApi = map['IdForApi'];
    }
    if (check('tHr', map)) {
      tHr = map['tHr'];
    }
    if (check('tSBP', map)) {
      tSbp = map['tSBP'];
    }
    if (check('tDBP', map)) {
      tDbp = map['tDBP'];
    }
    if (check('id', map)) {
      id = map['id'];
    }
    if (check('IsSync', map)) {
      isSync = map['IsSync'];
    }
    if (check('approxSBP', map)) {
      sbp = map['approxSBP'];
    }
    if (check('approxDBP', map)) {
      dbp = map['approxDBP'];
    }
    if (check('approxHr', map)) {
      hr = map['approxHr'].toInt();
    }

    if (map['hrv'] is num) {
      hrv = (map['hrv']).toInt();
    }
    if (check('hour', map)) {
      hour = map['hour'];
    }
    if (check('date', map)) {
      date = map['date'];
    }
    if (check('ecg', map)) {
      String strEcg = map['ecg'].toString();
      ecg = strEcg.split(',');
    }
    if (check('ppg', map)) {
      String strPpg = map['ppg'].toString();
      ppg = strPpg.split(',');
    }
    if (check('hrvs', map)) {
      String strPpg = map['hrvs'].toString();
      hrvs = strPpg.split(',');
    }

    if (check('DeviceType', map)) {
      deviceType = map['DeviceType'];
    }

    if (check('ID', map)) {
      idForApi = map['ID'];
    }
    if (check('data', map)) {
      Map data = map['data'][0];
      if (check('raw_ecg', data)) {
        List rawEcg = data['raw_ecg'];
        ecg = rawEcg.map((f) => f.toString()).toList();
      }
      if (check('raw_ppg', data)) {
        List rawPpg = data['raw_ppg'];
        ppg = rawPpg.map((f) => f.toString()).toList();
      }
  if (check('raw_hrv', data)) {
        List rawPpg = data['raw_hrv'];
        hrvs = rawPpg.map((f) => f.toString()).toList();
      }

      if (check('sys_manual', data)) {
        tSbp = double.parse(data['sys_manual'].toString()).toInt();
      }
      if (check('dias_manual', data)) {
        tDbp = double.parse(data['dias_manual'].toString()).toInt();
      }
      if (check('hr_manual', data)) {
        tHr = double.parse(data['hr_manual'].toString()).toInt();
      }

      if (check('BG', data)) {
        BG = double.parse(data['BG'].toString()).toInt();
      }
      if (check('Uncertainty', data)) {
        Uncertainty = double.parse(data['Uncertainty'].toString()).toInt();
      }

      if (check('BG1', data)) {
        BG1 = double.parse(data['BG1'].toString()).toInt();
      }

      if (check('Unit', data)) {
        Unit = data['Unit'];
      }   
      
      if (check('Unit1', data)) {
        Unit1 = data['Unit1'];
      }

      if (check('Class', data)) {
        Class = data['Class'];
      }

      if (check('dias_healthgauge', data)) {
        aiDbp = double.parse(data['dias_healthgauge'].toString()).toInt();
      }
      if (check('aiDbp', data)) {
        aiDbp = double.parse(data['aiDbp'].toString()).toInt();
      }
      if (check('sys_healthgauge', data)) {
        aiSBP = double.parse(data['sys_healthgauge'].toString()).toInt();
      }
      if (check('aiSBP', data)) {
        aiSBP = double.parse(data['aiSBP'].toString()).toInt();
      }

      if (check('AISys', data)) {
        aiSBP = double.parse(data['AISys'].toString()).toInt();
      }
      if (check('AIDias', data)) {
        aiDbp = double.parse(data['AIDias'].toString()).toInt();
      }

      if (check('dias_device', data)) {
        dbp = double.parse(data['dias_device'].toString()).toInt();
      }
      if (check('sys_device', data)) {
        sbp = double.parse(data['sys_device'].toString()).toInt();
      }
      if (check('hr_device', data)) {
        hr = double.parse(data['hr_device'].toString()).toInt();
      }
      if (check('hrv_device', data)) {
        hrv = double.parse(data['hrv_device'].toString()).toInt();
      }
      if (check('device_type', data)) {
        deviceType = data['device_type'];
      }

      if (check('timestamp', data)) {
        try {
          int timestamp = int.parse(data['timestamp'].toString());
          date = DateTime.fromMillisecondsSinceEpoch(timestamp).toString();
        } catch (e) {
          print(e);
        }
      }

      if (map['isForOscillometric'] is int) {
        isForOscillometric = getBoolFromInt(map['isForOscillometric']);
      }
      if (map['isForOscillometric'] is bool) {
        isForOscillometric = map['isForOscillometric'];
      }
    }

    if (map['isFromCamera'] is int) {
      isFromCamera = getBoolFromInt(map['isFromCamera']);
    }
    if (map['isFromCamera'] is bool) {
      isFromCamera = map['isFromCamera'];
    }

    if (map['isForHourlyHR'] is int) {
      isForHourlyHR = getBoolFromInt(map['isForHourlyHR']);
    }
    if (map['isForHourlyHR'] is bool) {
      isForHourlyHR = map['isForHourlyHR'];
    }

    if (map['isForTimeBasedPpg'] is int) {
      isForTimeBasedPpg = getBoolFromInt(map['isForTimeBasedPpg']);
    }
    if (map['isForTimeBasedPpg'] is bool) {
      isForTimeBasedPpg = map['isForTimeBasedPpg'];
    }

    if (map['IsCalibration'] is int) {
      isCalibration = getBoolFromInt(map['IsCalibration']);
    }
    if (map['IsCalibration'] is bool) {
      isCalibration = map['IsCalibration'];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'IdForApi': idForApi,
      'date': date,
      'ecg': ecg?.join(',') ?? '',
      'ppg': ppg?.join(',') ?? '',
      'hrvs': hrvs?.join(',') ?? '',
      'tHr': tHr,
      'tSBP': tSbp,
      'tDBP': tDbp,
      'approxSBP': sbp,
      'approxDBP': dbp,
      'approxHr': hr,
      'hrv': hrv,
      'BG': BG,
      'Uncertainty': Uncertainty,
      'BG1': BG1,
      'Unit': Unit,
      'Unit1' : Unit1,
      'Class' : Class,
      'aiSBP': aiSBP,
      'aiDBP': aiDbp,
      'IsCalibration': isCalibration ?? false,
      'isFromCamera': isFromCamera ?? false,
      'isForHourlyHR': isForHourlyHR ?? false,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'IdForApi': idForApi,
      'date': date,
      'ecg': ecg?.join(',') ?? '',
      'ppg': ppg?.join(',') ?? '',
      'hrvs': hrvs?.join(',') ?? '',
      'tHr': tHr,
      'tSBP': tSbp,
      'tDBP': tDbp,
      'approxSBP': sbp,
      'approxDBP': dbp,
      'approxHr': hr,
      'hrv': hrv,
      'BG': BG,
      'Uncertainty': Uncertainty,
      'BG1': BG1,
      'Unit': Unit,
      'Unit1' : Unit1,
      'Class' : Class,
      'aiSBP': aiSBP,
      'aiDBP': aiDbp,
      'IsCalibration': isCalibration ?? false,
      'isFromCamera': isFromCamera ?? false,
      'isForHourlyHR': isForHourlyHR ?? false,
    };
  }

  Map<String, dynamic> toMapDB(){
    return {
      'id': id,
      'approxSBP':sbp,
      'approxDBP':dbp,
      'approxHr':hr,
      'hrv':hrv,
      'BG': BG,
      'Uncertainty': Uncertainty,
      'BG1': BG1,
      'Unit': Unit,
      'Unit1' : Unit1,
      'Class' : Class,
      'ecgValue':0.0,
      'ppgValue':0.0,
      'date':date,
      'ecg':ecg?.join(','),
      'ppg':ppg?.join(','),
      'hrvs':hrvs?.join(','),
      'tHr':tHr,
      'tSBP':tSbp,
      'tDBP':tDbp,
      'aiSBP':aiSBP,
      'aiDBP':aiDbp,
      'isForHourlyHR':getIntFromBool(isForHourlyHR??false),
      'isForTimeBasedPpg':getIntFromBool(isForTimeBasedPpg??false),
      'IsCalibration':getIntFromBool(isCalibration??false),
      'isFromCamera':getIntFromBool(isFromCamera??false),
      'IdForApi':idForApi,
      'IsSync':isSync,
    };
  }

  int getIntFromBool(bool val){
    if(val){
      return 1;
    }
    return 0;
  }

  bool getBoolFromInt(int val){
    return val == 1;
  }

  check(String key, Map map) {
    if(map[key] != null){
      if (map[key] is String && map[key] == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }

  MeasurementHistoryModel.clone(MeasurementHistoryModel measurementHistoryItem) {
    id = measurementHistoryItem.id;
    isSync = measurementHistoryItem.isSync;
    sbp = measurementHistoryItem.sbp;
    dbp = measurementHistoryItem.dbp;
    hr = measurementHistoryItem.hr;
    hrv = measurementHistoryItem.hrv;
    BG = measurementHistoryItem.BG;
    Uncertainty = measurementHistoryItem.Uncertainty;
    BG1 = measurementHistoryItem.BG1;
    Unit = measurementHistoryItem.Unit;
    Unit1 = measurementHistoryItem.Unit1;
    Class = measurementHistoryItem.Class;
    hour = measurementHistoryItem.hour;
    date = measurementHistoryItem.date;
    ecg = measurementHistoryItem.ecg;
    ppg = measurementHistoryItem.ppg;
    hrvs = measurementHistoryItem.hrvs;
    tSbp = measurementHistoryItem.tSbp;
    tDbp = measurementHistoryItem.tDbp;
    tHr = measurementHistoryItem.tHr;
    idForApi = measurementHistoryItem.idForApi;
    isForHourlyHR = measurementHistoryItem.isForHourlyHR;
    isForTimeBasedPpg=measurementHistoryItem.isForTimeBasedPpg;
    deviceType = measurementHistoryItem.deviceType;

  }
}

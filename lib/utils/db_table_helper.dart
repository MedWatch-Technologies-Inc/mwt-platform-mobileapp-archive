class DBTableHelper {
  static final DBTableHelper _singleton = DBTableHelper._internal();

  factory DBTableHelper() {
    return _singleton;
  }

  DBTableHelper._internal();

  BPHistory bp = BPHistory();
  MHistory m = MHistory();
  THistory t = THistory();
  OTPHistory ot = OTPHistory();
  HRMonitorSync hr = HRMonitorSync();
  Activity ac = Activity();
  WHistory w = WHistory();
}

class WHistory{
  String table = 'WeightHistory';
  String columnID = 'WeightMeasurementID';
  String columnUID = 'UserID';
  String columnWeightSum = 'WeightSum';
  String columnBMI = 'BMI';
  String columnFatRate = 'FatRate';
  String columnMuscle = 'Muscle';
  String columnMoisture = 'Moisture';
  String columnBoneMass = 'BoneMass';
  String columnSubcutaneousFat = 'SubcutaneousFat';
  String columnBMR = 'BMR';
  String columnProteinRate = 'ProteinRate';
  String columnVisceralFat = 'VisceralFat';
  String columnPhysicalAge = 'PhysicalAge';
  String columnStandardWeight = 'StandardWeight';
  String columnWeightControl = 'WeightControl';
  String columnFatMass = 'FatMass';
  String columnWeightWithoutFat = 'WeightWithoutFat';
  String columnMuscleMass = 'MuscleMass';
  String columnProteinMass = 'ProteinMass';
  String columnFatLevel = 'FatLevel';
  String columnCreatedDateTime = 'CreatedDateTime';
  String columnCreatedDateTimeStamp = 'CreatedDateTimeStamp';
  String columnIsActive = 'IsActive';
  String columnIsDelete = 'IsDelete';
  String columnWeightUnit = 'WeightUnit';
}

class Activity{
  String table = 'HrMonitoringTable';
  String columnDBID = 'id';
  String columnDate = 'date';
  String columnTimestamp = 'CreatedDateTimeStamp';
  String columnUID = 'user_Id';
  String columnID = 'IdForApi';
  String columnStep = 'step';
  String columnKcal = 'calories';
  String columnDistance = 'distance';
}

class HRMonitorSync{
  String table = 'HrMonitoringTable';
  String columnID = 'idForApi';
  String columnDBID = 'id';
  String columnUID = 'userId';
  String columnDate = 'date';
  String columnHR = 'approxHr';
  String columnZone = 'ZoneID';
}

class BPHistory {
  String table = 'BloodPressure';
  String columnID = 'idForApi';
  String columnDBID = 'id';
  String columnUID = 'userId';
  String columnDate = 'date';
  String columnSys = 'bloodSBP';
  String columnDia = 'bloodDBP';
}

class OTPHistory {
  String table = 'Temperature';
  String columnID = 'idForApi';
  String columnDBID = 'id';
  String columnUID = 'UserId';
  String columnDate = 'date';
  String columnTemp = 'Temperature';
  String columnOxy= 'Oxygen';
  String columnCVRR = 'CVRR';
  String columnHRV = 'HRV';
  String columnHR = 'HeartRate';
  String columnTimestamp = 'timestamp';
}

class MHistory {
  String table = 'MHistory';
  String columnID = 'ID';
  String columnUID = 'userID';
  String columnTID = 'TransactionID';
  String columnData = 'data';
  String columnTimestamp = 'timestamp';
  String columnSBP = 'approxSBP';
  String columnDBP = 'approxDBP';
  String columnDate = 'date';
}

class THistory{
  String table = 'THistory';
  String columnID = 'ID';
  String columnTagLabelID = 'FKTagLabelID';
  String columnTagValue = 'TagValue';
  String columnNote = 'Note';
  String columnFKUserID = 'FKUserID';
  String columnTypeName = 'TypeName';
  String columnCreatedDateTime= 'CreatedDateTime';
  String columnCreatedDateTimeTimestamp = 'CreatedDateTimeTimestamp';
  String columnUnitSelectedType = 'UnitSelectedType';
  String columnTagImage = 'TagImage';
  String columnTagLabelName = 'TagLabelName';
  String columnAttachFiles = 'AttachFiles';
}

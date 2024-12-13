import 'package:flutter/material.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weight_measurement_model.g.dart';

@JsonSerializable()
class WeightMeasurementModel extends Object {
  @JsonKey(name: 'WeightMeasurementID')
  int? weightMeasurementID;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'WeightSum')
  double? weightSum;

  @JsonKey(name: 'BMI')
  double? bMI;

  @JsonKey(name: 'FatRate')
  double? fatRate;

  @JsonKey(name: 'Muscle')
  double? muscle;

  @JsonKey(name: 'Moisture')
  double? moisture;

  @JsonKey(name: 'BoneMass')
  double? boneMass;

  @JsonKey(name: 'SubcutaneousFat')
  double? subcutaneousFat;

  @JsonKey(name: 'BMR')
  double? bMR;

  @JsonKey(name: 'ProteinRate')
  double? proteinRate;

  @JsonKey(name: 'VisceralFat')
  double? visceralFat;

  @JsonKey(name: 'PhysicalAge')
  double? physicalAge;

  @JsonKey(name: 'StandardWeight')
  double? standardWeight;

  @JsonKey(name: 'WeightControl')
  double? weightControl;

  @JsonKey(name: 'FatMass')
  double? fatMass;

  @JsonKey(name: 'WeightWithoutFat')
  double? weightWithoutFat;

  @JsonKey(name: 'MuscleMass')
  double? muscleMass;

  @JsonKey(name: 'ProteinMass')
  double? proteinMass;

  @JsonKey(name: 'FatLevel')
  int? fatLevel;

  @JsonKey(name: 'CreatedDateTime')
  String? createdDateTime;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  @JsonKey(name: 'IsActive')
  bool? isActive;

  @JsonKey(name: 'IsDelete')
  bool? isDelete;

  @JsonKey(name: 'IdForApi')
  int? _idForApi;

  @JsonKey(name: 'isSync')
  int? isSync;

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'date')
  DateTime? date;

  WeightMeasurementModel({
    this.weightMeasurementID,
    this.userID,
    this.weightSum,
    this.bMI,
    this.fatRate,
    this.muscle,
    this.moisture,
    this.boneMass,
    this.subcutaneousFat,
    this.bMR,
    this.proteinRate,
    this.visceralFat,
    this.physicalAge,
    this.standardWeight,
    this.weightControl,
    this.fatMass,
    this.weightWithoutFat,
    this.muscleMass,
    this.proteinMass,
    this.fatLevel,
    this.createdDateTime,
    this.createdDateTimeStamp,
    this.isActive,
    this.isDelete,
    int? idForApi,
    this.isSync,
    this.id,
    this.date,
  }) {
    _idForApi = idForApi;
  }

  int? get idForApi => _idForApi ?? weightMeasurementID;

  set idForApi(int? idForApi) {
    _idForApi = idForApi;
  }

  factory WeightMeasurementModel.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('CreatedDateTime')) {
      srcJson['date'] = DateTime.fromMillisecondsSinceEpoch(int.parse(srcJson['CreatedDateTimeStamp'])).toString();
    }
    return _$WeightMeasurementModelFromJson(srcJson);
  }

  Map<String, dynamic> toJson() {
    var map = _$WeightMeasurementModelToJson(this);
    if (map.containsKey('WeightMeasurementID')) {
      map.remove('WeightMeasurementID');
    }
    if (map.containsKey('CreatedDateTime')) {
      map.remove('CreatedDateTime');
    }
    if (map.containsKey('CreatedDateTimeStamp')) {
      map.remove('CreatedDateTimeStamp');
    }
    if (map.containsKey('IsActive')) {
      map.remove('IsActive');
    }
    if (map.containsKey('IsDelete')) {
      map.remove('IsDelete');
    }
    return map;
  }

  // todo replace this later when migrating db
  WeightMeasurementModel.fromMap(Map map) {
    try {
      if (check('date', map)) {
        date = DateFormat(DateUtil.yyyyMMdd).parse(map['date'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    try {
      if (check('time', map)) {
        var hr = int.parse(map['time'].toString().split(':')[0]);
        var minute = int.parse(map['time'].toString().split(':')[1]);
        var seconds = int.parse(map['time'].toString().split(':')[2]);
        if (date != null) {
          date =
              DateTime(date!.year, date!.month, date!.day, hr, minute, seconds);
        }
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    try {
      if (check('moisture', map)) {
        moisture = double.parse(map['moisture'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    try {
      if (check('BMI', map)) {
        bMI = double.parse(map['BMI'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    try {
      if (check('fatRate', map)) {
        fatRate = double.parse(map['fatRate'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('muscle', map)) {
        muscle = double.parse(map['muscle'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('boneMass', map)) {
        boneMass = double.parse(map['boneMass'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('subcutaneousFat', map)) {
        subcutaneousFat = double.parse(map['subcutaneousFat'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('BMR', map)) {
        bMR = double.parse(map['BMR'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('proteinRate', map)) {
        proteinRate = double.parse(map['proteinRate'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('visceralFat', map)) {
        visceralFat = double.parse(map['visceralFat'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('physicalAge', map)) {
        physicalAge = double.parse(map['physicalAge'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('weightsum', map)) {
        weightSum = double.parse(map['weightsum'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('fatlevel', map)) {
        fatLevel = double.parse(map['fatlevel'].toString()).toInt();
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('fatMass', map)) {
        fatMass = double.parse(map['fatMass'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('muscleMass', map)) {
        muscleMass = double.parse(map['muscleMass'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('proteinMass', map)) {
        proteinMass = double.parse(map['proteinMass'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('standardWeight', map)) {
        standardWeight = double.parse(map['standardWeight'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('weightControl', map)) {
        weightControl = double.parse(map['weightControl'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('weightWithoutFat', map)) {
        weightWithoutFat = double.parse(map['weightWithoutFat'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    if (check('id', map)) {
      id = map['id'];
    }
  }

  WeightMeasurementModel.fromMapForLocalDataBase(Map map) {
    try {
      if (check('Date', map)) {
        date = DateTime.parse(map['Date'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    try {
      if (check('Moisture', map)) {
        moisture = double.parse(map['Moisture'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    try {
      if (check('BMI', map)) {
        bMI = double.parse(map['BMI'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    try {
      if (check('FatRate', map)) {
        fatRate = double.parse(map['FatRate'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('Muscle', map)) {
        muscle = double.parse(map['Muscle'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('BoneMass', map)) {
        boneMass = double.parse(map['BoneMass'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('SubcutaneousFat', map)) {
        subcutaneousFat = double.parse(map['SubcutaneousFat'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('BMR', map)) {
        bMR = double.parse(map['BMR'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('ProteinRate', map)) {
        proteinRate = double.parse(map['ProteinRate'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('VisceralFat', map)) {
        visceralFat = double.parse(map['VisceralFat'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('PhysicalAge', map)) {
        physicalAge = double.parse(map['PhysicalAge'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('WeightSum', map)) {
        weightSum = double.parse(map['WeightSum'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('FatLevel', map)) {
        fatLevel = double.parse(map['FatLevel'].toString()).toInt();
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('FatMass', map)) {
        fatMass = double.parse(map['FatMass'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('MuscleMass', map)) {
        muscleMass = double.parse(map['MuscleMass'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('ProteinMass', map)) {
        proteinMass = double.parse(map['ProteinMass'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('StandardWeight', map)) {
        standardWeight = double.parse(map['StandardWeight'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('WeightControl', map)) {
        weightControl = double.parse(map['WeightControl'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
    try {
      if (check('WeightWithoutFat', map)) {
        weightWithoutFat = double.parse(map['WeightWithoutFat'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    if (check('id', map)) {
      id = map['id'];
    }

    try {
      if (check('WeightMeasurementID', map)) {
        _idForApi = map['WeightMeasurementID'];
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    try {
      if (check('CreatedDateTime', map)) {
        date = DateTime.parse(map['CreatedDateTime'].toString());
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }

    try {
      if (check('IdForApi', map)) {
        _idForApi = map['IdForApi'];
      }
    } catch (e) {
      debugPrint('Exception at weightMeasurementModel $e');
    }
  }
}

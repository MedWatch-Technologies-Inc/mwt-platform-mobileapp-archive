import 'package:flutter/material.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:intl/intl.dart';

class WHistoryModel {
  int weightMeasurementID;
  int userID;
  num weightSum;
  num bmi;
  num fatRate;
  num muscle;
  num moisture;
  num boneMass;
  num subcutaneousFat;
  num bmr;
  num proteinRate;
  num visceralFat;
  num physicalAge;
  num standardWeight;
  num weightControl;
  num fatMass;
  num weightWithoutFat;
  num muscleMass;
  num proteinMass;
  num fatLevel;
  String createdDateTime;
  int createdDateTimeStamp;
  bool isActive;
  bool isDelete;

  WHistoryModel({
    required this.weightMeasurementID,
    required this.userID,
    required this.weightSum,
    required this.bmi,
    required this.fatRate,
    required this.muscle,
    required this.moisture,
    required this.boneMass,
    required this.subcutaneousFat,
    required this.bmr,
    required this.proteinRate,
    required this.visceralFat,
    required this.physicalAge,
    required this.standardWeight,
    required this.weightControl,
    required this.fatMass,
    required this.weightWithoutFat,
    required this.muscleMass,
    required this.proteinMass,
    required this.fatLevel,
    required this.createdDateTime,
    required this.createdDateTimeStamp,
    required this.isActive,
    required this.isDelete,
  });

  String get displayWeight {
    var tempWeight = weightSum;
    if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial) {
      tempWeight = weightSum * 2.20462;
      return '${tempWeight.toStringAsFixed(1)} ${stringLocalization.getText(StringLocalization.lb).toUpperCase()}';
    }
    return '${tempWeight.toStringAsFixed(1)} ${stringLocalization.getText(StringLocalization.kg).toUpperCase()}';
  }

  String get getDate => DateFormat(DateUtil.MMMddhhmma)
      .format(DateTime.fromMillisecondsSinceEpoch(createdDateTimeStamp));

  String get getTime =>
      DateFormat(DateUtil.hmma).format(DateTime.fromMillisecondsSinceEpoch(createdDateTimeStamp));

  final ValueNotifier<bool> showDetails = ValueNotifier(false);

  bool get isShowDetails => showDetails.value;

  set isShowDetails(bool value) {
    showDetails.value = value;
  }

  factory WHistoryModel.fromJson(Map<String, dynamic> json) {
    return WHistoryModel(
      weightMeasurementID: JsonSerializableUtils.instance.checkInt(json['WeightMeasurementID']),
      userID: JsonSerializableUtils.instance.checkInt(json['UserID']),
      weightSum: JsonSerializableUtils.instance.checkNum(json['WeightSum']),
      bmi: JsonSerializableUtils.instance.checkNum(json['BMI']),
      fatRate: JsonSerializableUtils.instance.checkNum(json['FatRate']),
      muscle: JsonSerializableUtils.instance.checkNum(json['Muscle']),
      moisture: JsonSerializableUtils.instance.checkNum(json['Moisture']),
      boneMass: JsonSerializableUtils.instance.checkNum(json['BoneMass']),
      subcutaneousFat: JsonSerializableUtils.instance.checkNum(json['SubcutaneousFat']),
      bmr: JsonSerializableUtils.instance.checkNum(json['BMR']),
      proteinRate: JsonSerializableUtils.instance.checkNum(json['ProteinRate']),
      visceralFat: JsonSerializableUtils.instance.checkNum(json['VisceralFat']),
      physicalAge: JsonSerializableUtils.instance.checkNum(json['PhysicalAge']),
      standardWeight: JsonSerializableUtils.instance.checkNum(json['StandardWeight']),
      weightControl: JsonSerializableUtils.instance.checkNum(json['WeightControl']),
      fatMass: JsonSerializableUtils.instance.checkNum(json['FatMass']),
      weightWithoutFat: JsonSerializableUtils.instance.checkNum(json['WeightWithoutFat']),
      muscleMass: JsonSerializableUtils.instance.checkNum(json['MuscleMass']),
      proteinMass: JsonSerializableUtils.instance.checkNum(json['ProteinMass']),
      fatLevel: JsonSerializableUtils.instance.checkNum(json['FatLevel']),
      createdDateTime: JsonSerializableUtils.instance.checkString(json['CreatedDateTime']),
      createdDateTimeStamp: JsonSerializableUtils.instance.checkInt(json['CreatedDateTimeStamp']),
      isActive: JsonSerializableUtils.instance.checkBool(json['IsActive']),
      isDelete: JsonSerializableUtils.instance.checkBool(json['IsDelete']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'WeightMeasurementID': weightMeasurementID,
      'UserID': userID,
      'WeightSum': weightSum,
      'BMI': bmi,
      'FatRate': fatRate,
      'Muscle': muscle,
      'Moisture': moisture,
      'BoneMass': boneMass,
      'SubcutaneousFat': subcutaneousFat,
      'BMR': bmr,
      'ProteinRate': proteinRate,
      'VisceralFat': visceralFat,
      'PhysicalAge': physicalAge,
      'StandardWeight': standardWeight,
      'WeightControl': weightControl,
      'FatMass': fatMass,
      'WeightWithoutFat': weightWithoutFat,
      'MuscleMass': muscleMass,
      'ProteinMass': proteinMass,
      'FatLevel': fatLevel,
      'CreatedDateTime': createdDateTime,
      'CreatedDateTimeStamp': createdDateTimeStamp,
      'IsActive': isActive,
      'IsDelete': isDelete,
      'WeightUnit': weightUnit,
    };
  }
}

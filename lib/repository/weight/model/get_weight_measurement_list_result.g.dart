// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_weight_measurement_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetWeightMeasurementListResult _$GetWeightMeasurementListResultFromJson(
        Map json) =>
    GetWeightMeasurementListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => WeightMeasurementModel.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GetWeightMeasurementListResultToJson(
        GetWeightMeasurementListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

GetWeightMeasurementListData _$GetWeightMeasurementListDataFromJson(Map json) =>
    GetWeightMeasurementListData(
      weightMeasurementID: json['WeightMeasurementID'] as int?,
      userID: json['UserID'] as int?,
      weightSum: json['WeightSum'] as int?,
      bMI: (json['BMI'] as num?)?.toDouble(),
      fatRate: json['FatRate'] as int?,
      muscle: json['Muscle'] as int?,
      moisture: json['Moisture'] as int?,
      boneMass: json['BoneMass'] as int?,
      subcutaneousFat: json['SubcutaneousFat'] as int?,
      bMR: json['BMR'] as int?,
      proteinRate: json['ProteinRate'] as int?,
      visceralFat: json['VisceralFat'] as int?,
      physicalAge: json['PhysicalAge'] as int?,
      standardWeight: json['StandardWeight'] as int?,
      weightControl: json['WeightControl'] as int?,
      fatMass: json['FatMass'] as int?,
      weightWithoutFat: json['WeightWithoutFat'] as int?,
      muscleMass: json['MuscleMass'] as int?,
      proteinMass: json['ProteinMass'] as int?,
      fatLevel: json['FatLevel'] as int?,
      createdDateTime: json['CreatedDateTime'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
      isActive: json['IsActive'] as bool?,
      isDelete: json['IsDelete'] as bool?,
    );

Map<String, dynamic> _$GetWeightMeasurementListDataToJson(
        GetWeightMeasurementListData instance) =>
    <String, dynamic>{
      'WeightMeasurementID': instance.weightMeasurementID,
      'UserID': instance.userID,
      'WeightSum': instance.weightSum,
      'BMI': instance.bMI,
      'FatRate': instance.fatRate,
      'Muscle': instance.muscle,
      'Moisture': instance.moisture,
      'BoneMass': instance.boneMass,
      'SubcutaneousFat': instance.subcutaneousFat,
      'BMR': instance.bMR,
      'ProteinRate': instance.proteinRate,
      'VisceralFat': instance.visceralFat,
      'PhysicalAge': instance.physicalAge,
      'StandardWeight': instance.standardWeight,
      'WeightControl': instance.weightControl,
      'FatMass': instance.fatMass,
      'WeightWithoutFat': instance.weightWithoutFat,
      'MuscleMass': instance.muscleMass,
      'ProteinMass': instance.proteinMass,
      'FatLevel': instance.fatLevel,
      'CreatedDateTime': instance.createdDateTime,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
      'IsActive': instance.isActive,
      'IsDelete': instance.isDelete,
    };

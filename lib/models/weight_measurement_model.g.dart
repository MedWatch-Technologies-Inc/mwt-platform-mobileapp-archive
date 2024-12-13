// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_measurement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightMeasurementModel _$WeightMeasurementModelFromJson(Map json) =>
    WeightMeasurementModel(
      weightMeasurementID: json['WeightMeasurementID'] as int?,
      userID: json['UserID'] as int?,
      weightSum: (json['WeightSum'] as num?)?.toDouble(),
      bMI: (json['BMI'] as num?)?.toDouble(),
      fatRate: (json['FatRate'] as num?)?.toDouble(),
      muscle: (json['Muscle'] as num?)?.toDouble(),
      moisture: (json['Moisture'] as num?)?.toDouble(),
      boneMass: (json['BoneMass'] as num?)?.toDouble(),
      subcutaneousFat: (json['SubcutaneousFat'] as num?)?.toDouble(),
      bMR: (json['BMR'] as num?)?.toDouble(),
      proteinRate: (json['ProteinRate'] as num?)?.toDouble(),
      visceralFat: (json['VisceralFat'] as num?)?.toDouble(),
      physicalAge: (json['PhysicalAge'] as num?)?.toDouble(),
      standardWeight: (json['StandardWeight'] as num?)?.toDouble(),
      weightControl: (json['WeightControl'] as num?)?.toDouble(),
      fatMass: (json['FatMass'] as num?)?.toDouble(),
      weightWithoutFat: (json['WeightWithoutFat'] as num?)?.toDouble(),
      muscleMass: (json['MuscleMass'] as num?)?.toDouble(),
      proteinMass: (json['ProteinMass'] as num?)?.toDouble(),
      fatLevel: json['FatLevel'] as int?,
      createdDateTime: json['CreatedDateTime'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
      isActive: json['IsActive'] as bool?,
      isDelete: json['IsDelete'] as bool?,
      idForApi: json['idForApi'] as int?,
      isSync: json['isSync'] as int?,
      id: json['id'] as int?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$WeightMeasurementModelToJson(
        WeightMeasurementModel instance) =>
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
      'isSync': instance.isSync,
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'idForApi': instance.idForApi,
    };

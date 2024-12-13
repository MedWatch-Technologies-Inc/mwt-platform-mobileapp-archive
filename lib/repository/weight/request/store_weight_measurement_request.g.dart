// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_weight_measurement_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreWeightMeasurementRequest _$StoreWeightMeasurementRequestFromJson(
        Map json) =>
    StoreWeightMeasurementRequest(
      userId: json['userId'] as String?,
      weightSum: (json['weightsum'] as num?)?.toDouble(),
      bMI: (json['bMI'] as num?)?.toDouble(),
      createdDateTime: json['CreatedDateTime'] as String?,
      bMR: (json['bMR'] as num?)?.toDouble(),
      boneMass: (json['boneMass'] as num?)?.toDouble(),
      fatLevel: json['fatlevel'] as int?,
      fatMass: (json['fatMass'] as num?)?.toDouble(),
      fatRate: (json['fatRate'] as num?)?.toDouble(),
      moisture: (json['moisture'] as num?)?.toDouble(),
      muscle: (json['muscle'] as num?)?.toDouble(),
      muscleMass: (json['muscleMass'] as num?)?.toDouble(),
      physicalAge: (json['physicalAge'] as num?)?.toDouble(),
      proteinMass: (json['proteinMass'] as num?)?.toDouble(),
      proteinRate: (json['proteinRate'] as num?)?.toDouble(),
      standardWeight: (json['standardWeight'] as num?)?.toDouble(),
      subcutaneousFat: (json['subcutaneousFat'] as num?)?.toDouble(),
      visceralFat: (json['visceralFat'] as num?)?.toDouble(),
      weightControl: (json['weightControl'] as num?)?.toDouble(),
      weightWithoutFat: (json['weightWithoutFat'] as num?)?.toDouble(),
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$StoreWeightMeasurementRequestToJson(
        StoreWeightMeasurementRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'weightsum': instance.weightSum,
      'bMI': instance.bMI,
      'fatRate': instance.fatRate,
      'muscle': instance.muscle,
      'moisture': instance.moisture,
      'boneMass': instance.boneMass,
      'subcutaneousFat': instance.subcutaneousFat,
      'bMR': instance.bMR,
      'proteinRate': instance.proteinRate,
      'visceralFat': instance.visceralFat,
      'physicalAge': instance.physicalAge,
      'standardWeight': instance.standardWeight,
      'weightControl': instance.weightControl,
      'fatMass': instance.fatMass,
      'weightWithoutFat': instance.weightWithoutFat,
      'muscleMass': instance.muscleMass,
      'proteinMass': instance.proteinMass,
      'fatlevel': instance.fatLevel,
      'CreatedDateTime': instance.createdDateTime,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

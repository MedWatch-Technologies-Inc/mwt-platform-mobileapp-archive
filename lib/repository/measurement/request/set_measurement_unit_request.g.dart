// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_measurement_unit_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetMeasurementUnitRequest _$SetMeasurementUnitRequestFromJson(Map json) =>
    SetMeasurementUnitRequest(
      unitData: (json['UnitData'] as List<dynamic>?)
          ?.map((e) => SetMeasurementUnitData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$SetMeasurementUnitRequestToJson(
        SetMeasurementUnitRequest instance) =>
    <String, dynamic>{
      'UnitData': instance.unitData?.map((e) => e.toJson()).toList(),
    };

SetMeasurementUnitData _$SetMeasurementUnitDataFromJson(Map json) =>
    SetMeasurementUnitData(
      userID: json['UserID'] as String?,
      measurement: json['Measurement'] as String?,
      unit: json['Unit'] as String?,
      value: json['Value'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$SetMeasurementUnitDataToJson(
        SetMeasurementUnitData instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'Measurement': instance.measurement,
      'Unit': instance.unit,
      'Value': instance.value,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

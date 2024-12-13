// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_measurement_unit_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetMeasurementUnitResult _$SetMeasurementUnitResultFromJson(Map json) =>
    SetMeasurementUnitResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      iD: json['IDs'] as String?,
    );

Map<String, dynamic> _$SetMeasurementUnitResultToJson(
        SetMeasurementUnitResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'IDs': instance.iD,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_weight_measurement_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreWeightMeasurementResult _$StoreWeightMeasurementResultFromJson(Map json) =>
    StoreWeightMeasurementResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      iD: (json['ID'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$StoreWeightMeasurementResultToJson(
        StoreWeightMeasurementResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'ID': instance.iD,
    };

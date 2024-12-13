// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_measurement_detail_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMeasurementDetailListResult _$GetMeasurementDetailListResultFromJson(Map json) =>
    GetMeasurementDetailListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => MeasurementHistoryModel.fromJson(e as Map))
          .toList(),
    );

Map<String, dynamic> _$GetMeasurementDetailListResultToJson(
        GetMeasurementDetailListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

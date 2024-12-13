// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_estimate_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteEstimateResult _$DeleteEstimateResultFromJson(Map json) =>
    DeleteEstimateResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      iD: json['ID'] as int?,
    );

Map<String, dynamic> _$DeleteEstimateResultToJson(
        DeleteEstimateResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'ID': instance.iD,
    };

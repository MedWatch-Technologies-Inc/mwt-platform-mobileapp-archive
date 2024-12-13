// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estimate_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EstimateResult _$EstimateResultFromJson(Map json) => EstimateResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      iD: json['ID'] as int?,
      data: json['Data'] as String?,
      sBP: json['SBP'] as int?,
      dBP: json['DBP'] as int?,
      value: json['value'],
      BG: double.tryParse(json['BG'].toString())?.toInt(),
      Uncertainty: json['Uncertainty'] as int?,
      BG1: double.tryParse(json['BG1'].toString())?.toInt(),
      Unit: json['Unit'] as String?,
      Unit1: json['Unit1'] as String?,
      Class: json['Class'] as String?,
    );

Map<String, dynamic> _$EstimateResultToJson(EstimateResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'ID': instance.iD,
      'Data': instance.data,
      'SBP': instance.sBP,
      'DBP': instance.dBP,
      'value': instance.value,
      'BG': instance.BG,
      'Uncertainty': instance.Uncertainty,
       'BG1': instance.BG1,
       'Unit': instance.Unit,
       'Unit1' : instance.Unit1,
       'Class' : instance.Class
    };

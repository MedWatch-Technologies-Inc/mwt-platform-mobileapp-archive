// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_measurement_count_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllMeasurementCountResult _$GetAllMeasurementCountResultFromJson(Map json) =>
    GetAllMeasurementCountResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      allMeasurementCount: json['Data'] == null
          ? null
          :json['Data'] is Map? AllMeasurementCount.fromJson(
              Map<String, dynamic>.from(json['Data'] as Map)):null,
    );

Map<String, dynamic> _$GetAllMeasurementCountResultToJson(
        GetAllMeasurementCountResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.allMeasurementCount?.toJson(),
    };

AllMeasurementCount _$AllMeasurementCountFromJson(Map json) =>
    AllMeasurementCount(
      json['UserID'] as int?,
      json['MeasurementCount'] as int?,
      json['WorkActivityCount'] as int?,
      json['SleepActivityCount'] as int?,
      json['WeightScaleCount'] as int?,
      json['TagHistoryCount'] as int?,
      json['TagLabelCount'] as int?,
      json['ContactCount'] as int?,
      json['UserVitalStatusCount'] as int?,
    );

Map<String, dynamic> _$AllMeasurementCountToJson(
        AllMeasurementCount instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'MeasurementCount': instance.measurementCount,
      'WorkActivityCount': instance.workActivityCount,
      'SleepActivityCount': instance.sleepActivityCount,
      'WeightScaleCount': instance.weightScaleCount,
      'TagHistoryCount': instance.tagHistoryCount,
      'TagLabelCount': instance.tagLabelCount,
      'ContactCount': instance.contactCount,
      'UserVitalStatusCount': instance.userVitalStatusCount,
    };

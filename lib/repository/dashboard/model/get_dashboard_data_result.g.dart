// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_dashboard_data_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDashboardDataResult _$GetDashboardDataResultFromJson(Map json) =>
    GetDashboardDataResult(
      result: json['Result'] as bool?,
      motionInfoModel: json['ActivityDetails'] == null
          ? null
          : MotionInfoModel.fromJson(json['ActivityDetails'] as Map),
      weightMeasurementModel: json['WeightDetails'] == null
          ? null
          : WeightMeasurementModel.fromJson(
              Map<String, dynamic>.from(json['WeightDetails'] as Map)),
      measurementHistoryModel: json['MesurmentDetails'] == null
          ? null
          : MeasurementHistoryModel.fromJson(json['MesurmentDetails'] as Map),
      sleepInfoModel: json['SleepData'] == null
          ? null
          : SleepInfoModel.fromJson(json['SleepData'] as Map),
      tempModel: (json['UserVitalStatus'] as List<dynamic>?)
          ?.map((e) => TempModel.fromJson(e as Map))
          .toList(),
    );

Map<String, dynamic> _$GetDashboardDataResultToJson(
        GetDashboardDataResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'SleepData': instance.sleepInfoModel?.toJson(),
      'WeightDetails': instance.weightMeasurementModel?.toJson(),
      'ActivityDetails': instance.motionInfoModel?.toJson(),
      'MesurmentDetails': instance.measurementHistoryModel?.toJson(),
      'UserVitalStatus': instance.tempModel?.map((e) => e.toJson()).toList(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_hr_monitoring.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddHrMonitoring _$AddHrMonitoringFromJson(Map json) => AddHrMonitoring(
      json['userId'] as int,
      (json['hrData'] as List<dynamic>)
          .map((e) => HrData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      json['idForApi'] as int,
    );

Map<String, dynamic> _$AddHrMonitoringToJson(AddHrMonitoring instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'hrData': instance.hrData.map((e) => e.toJson()).toList(),
      'idForApi': instance.idForApi,
    };

HrData _$HrDataFromJson(Map json) => HrData(
      json['date'] as String,
      json['hr'] as int,
    );

Map<String, dynamic> _$HrDataToJson(HrData instance) => <String, dynamic>{
      'date': instance.date,
      'hr': instance.hr,
    };

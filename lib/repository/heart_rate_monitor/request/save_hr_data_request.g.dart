// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_hr_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveHrDataRequest _$SaveHrDataRequestFromJson(Map json) => SaveHrDataRequest(
      json['userId'] as int,
      (json['hrData'] as List<dynamic>)
          .map((e) => HrData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$SaveHrDataRequestToJson(SaveHrDataRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'hrData': instance.hrData.map((e) => e.toJson()).toList(),
    };

HrData _$HrDataFromJson(Map json) => HrData(
      json['hr'] as int,
      json['date'] as String,
      json['ZoneID'] as int,
);

Map<String, dynamic> _$HrDataToJson(HrData instance) => <String, dynamic>{
      'hr': instance.hr,
      'date': instance.date,
      'ZoneID': instance.ZoneID,
    };

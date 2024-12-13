// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_user_vital_status_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveUserVitalStatusRequest _$SaveUserVitalStatusRequestFromJson(Map json) =>
    SaveUserVitalStatusRequest(
      userId: json['FKUserID'] as String?,
      oxygen: json['Oxygen'] as num?,
      HRV: json['HRV'] as num?,
      cvrrValue: json['CVRR'] as num?,
      heartValue: json['HeartRate'] as num?,
      date: json['CreatedDateTime'] as String?,
      temperature: json['Temperature'] as num?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$SaveUserVitalStatusRequestToJson(
        SaveUserVitalStatusRequest instance) =>
    <String, dynamic>{
      'Oxygen': instance.oxygen,
      'HRV': instance.HRV,
      'CVRR': instance.cvrrValue,
      'HeartRate': instance.heartValue,
      'CreatedDateTime': instance.date,
      'Temperature': instance.temperature,
      'FKUserID': instance.userId,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_measurement_count_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllMeasurementCountRequest _$GetAllMeasurementCountRequestFromJson(
        Map json) =>
    GetAllMeasurementCountRequest(
      userId: json['UserId'] as String?,
      fromDateStamp: json['FromDateStamp'] as String?,
      toDateStamp: json['ToDateStamp'] as String?,
    );

Map<String, dynamic> _$GetAllMeasurementCountRequestToJson(
        GetAllMeasurementCountRequest instance) =>
    <String, dynamic>{
      'UserId': instance.userId,
      'FromDateStamp': instance.fromDateStamp,
      'ToDateStamp': instance.toDateStamp,
    };

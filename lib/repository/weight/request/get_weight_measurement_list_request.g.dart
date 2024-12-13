// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_weight_measurement_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetWeightMeasurementListRequest _$GetWeightMeasurementListRequestFromJson(
        Map json) =>
    GetWeightMeasurementListRequest(
      userID: json['UserID'] as String?,
      pageIndex: json['PageIndex'] as int?,
      pageSize: json['PageSize'] as int?,
      iDs: json['IDs'] as List<dynamic>?,
      fromDate: json['FromDate'] as String?,
      toDate: json['ToDate'] as String?,
      fromDateStamp: json['FromDateStamp'] as String?,
      toDateStamp: json['ToDateStamp'] as String?,
    );

Map<String, dynamic> _$GetWeightMeasurementListRequestToJson(
        GetWeightMeasurementListRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'PageIndex': instance.pageIndex,
      'PageSize': instance.pageSize,
      'IDs': instance.iDs,
      'FromDate': instance.fromDate,
      'ToDate': instance.toDate,
      'FromDateStamp': instance.fromDateStamp,
      'ToDateStamp': instance.toDateStamp,
    };

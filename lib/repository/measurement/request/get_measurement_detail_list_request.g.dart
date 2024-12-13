// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_measurement_detail_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMeasurementDetailListRequest _$GetMeasurementDetailListRequestFromJson(
        Map json) =>
    GetMeasurementDetailListRequest(
      userID: json['UserID'] as String?,
      pageIndex: json['PageIndex'] as int?,
      pageSize: json['PageSize'] as int?,
      iDs: json['IDs'] as List<dynamic>?,
      fromDate: json['FromDate'] as String?,
      toDate: json['ToDate'] as String?,
      toDateStamp: json['ToDateStamp'] as String?,
      fromDateStamp: json['FromDateStamp'] as String?,
    );

Map<String, dynamic> _$GetMeasurementDetailListRequestToJson(
        GetMeasurementDetailListRequest instance) =>
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

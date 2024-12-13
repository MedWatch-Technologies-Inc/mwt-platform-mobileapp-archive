// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_hr_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHrDataRequest _$GetHrDataRequestFromJson(Map json) => GetHrDataRequest(
      userId: json['userId'] as int?,
      // fromDateStamp: json['FromDateStamp'] as String?,
      // toDateStamp: json['ToDateStamp'] as String?,
      pageIndex: json['PageIndex'] as int?,
      pageSize: json['PageSize'] as int?,
      ids: json['IDs'] as List<dynamic>?,
    );

Map<String, dynamic> _$GetHrDataRequestToJson(GetHrDataRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'FromDateStamp': instance.fromDateStamp,
      'ToDateStamp': instance.toDateStamp,
      'PageIndex': instance.pageIndex,
      'PageSize': instance.pageSize,
      'IDs': instance.ids,
    };

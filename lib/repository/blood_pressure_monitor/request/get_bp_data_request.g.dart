// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bp_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBPDataRequest _$GetBPDataRequestFromJson(Map json) => GetBPDataRequest(
      userId: json['userId'] as int?,
      fromDateStamp: json['FromDateStamp'] as String?,
      toDateStamp: json['ToDateStamp'] as String?,
      pageIndex: json['PageIndex'] as int?,
      pageSize: json['PageSize'] as int?,
      iDs: json['IDs'] as List<dynamic>?,
    );

Map<String, dynamic> _$GetBPDataRequestToJson(GetBPDataRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'FromDateStamp': instance.fromDateStamp,
      'ToDateStamp': instance.toDateStamp,
      'PageIndex': instance.pageIndex,
      'PageSize': instance.pageSize,
      'IDs': instance.iDs,
    };

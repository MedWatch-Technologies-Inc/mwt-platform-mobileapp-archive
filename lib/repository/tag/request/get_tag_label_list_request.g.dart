// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_tag_label_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTagLabelListRequest _$GetTagLabelListRequestFromJson(Map json) =>
    GetTagLabelListRequest(
      userID: json['UserID'] as String?,
      pageIndex: json['PageIndex'] as int?,
      pageSize: json['PageSize'] as int?,
      fromDate: json['FromDate'] as String?,
      toDate: json['ToDate'] as String?,
      iDs: json['IDs'] as List<dynamic>?,
      fromDateStamp: json['FromDateStamp'] as String?,
      toDateStamp: json['ToDateStamp'] as String?,
    );

Map<String, dynamic> _$GetTagLabelListRequestToJson(
        GetTagLabelListRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'PageIndex': instance.pageIndex,
      'PageSize': instance.pageSize,
      'FromDate': instance.fromDate,
      'ToDate': instance.toDate,
      'IDs': instance.iDs,
      'FromDateStamp': instance.fromDateStamp,
      'ToDateStamp': instance.toDateStamp,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_recognition_activity_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetRecognitionActivityListRequest _$GetRecognitionActivityListRequestFromJson(
        Map json) =>
    GetRecognitionActivityListRequest(
      userID: json['UserID'] as int?,
      pageIndex: json['PageIndex'] as int?,
      pageSize: json['PageSize'] as int?,
      fromDate: json['FromDate'] as String?,
      toDate: json['ToDate'] as String?,
      iDs: (json['IDs'] as List<dynamic>?)?.map((e) => e as int).toList(),
      toDateStamp: json['ToDateStamp'] as String?,
      fromDateStamp: json['FromDateStamp'] as String?,
    );

Map<String, dynamic> _$GetRecognitionActivityListRequestToJson(
        GetRecognitionActivityListRequest instance) =>
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

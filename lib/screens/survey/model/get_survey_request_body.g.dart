// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_survey_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSurveysRequestBody _$GetSurveysRequestBodyFromJson(Map json) =>
    GetSurveysRequestBody(
      json['UserID'] as int,
      json['FromDateStamp'] as String?,
      json['ToDateStamp'] as String?,
      json['PageIndex'] as int,
      json['PageSize'] as int,
    );

Map<String, dynamic> _$GetSurveysRequestBodyToJson(
        GetSurveysRequestBody instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'FromDateStamp': instance.fromDateStamp,
      'ToDateStamp': instance.toDateStamp,
      'PageIndex': instance.pageIndex,
      'PageSize': instance.pageSize,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_survey_with_contacts_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareSurveyWithContactsRequestBody _$ShareSurveyWithContactsRequestBodyFromJson(Map json) =>
    ShareSurveyWithContactsRequestBody(
      json['FKUserID'] as int,
      json['SurveyID'] as int,
      json['ShredUserIDList'] as String?,
      json['PhysicalUrl'] as String?,
      json['StartDateTimeStamp'] as String,
    );

Map<String, dynamic> _$ShareSurveyWithContactsRequestBodyToJson(
    ShareSurveyWithContactsRequestBody instance) =>
    <String, dynamic>{
      'FKUserID': instance.fkUserID,
      'SurveyID': instance.surveyId,
      'ShredUserIDList': instance.sharedUserIdList,
      'PhysicalUrl': instance.physicalUrl??'',
      'StartDateTimeStamp': instance.startDateDateStamp,
    };

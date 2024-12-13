// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_survey_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareSurveyResponseModel _$ShareSurveyResponseModelFromJson(
    Map json) =>
    ShareSurveyResponseModel(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$ShareSurveyResponseModelToJson(
    ShareSurveyResponseModel instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_and_save_survey_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAndSaveSurveyResponseModel _$CreateAndSaveSurveyResponseModelFromJson(
        Map json) =>
    CreateAndSaveSurveyResponseModel(
      result: json['Result'] as bool?,
      id: json['ID'] as int?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$CreateAndSaveSurveyResponseModelToJson(
        CreateAndSaveSurveyResponseModel instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'ID': instance.id,
      'Response': instance.response,
      'Message': instance.message,
    };

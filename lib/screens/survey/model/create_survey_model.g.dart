// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_survey_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSurveyModel _$CreateSurveyModelFromJson(Map json) => CreateSurveyModel(
      surveyName: json['SurveyName'] as String?,
      fKUserID: json['FKUserID'] as int?,
      startDateTimeStamp: json['StartDateTimeStamp'] as String?,
      endDateTimeStamp: json['EndDateTimeStamp'] as String?,
      lstQuestion: (json['lstQuestion'] as List<dynamic>?)
          ?.map((e) => LstQuestion.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$CreateSurveyModelToJson(CreateSurveyModel instance) =>
    <String, dynamic>{
      'SurveyName': instance.surveyName,
      'FKUserID': instance.fKUserID,
      'StartDateTimeStamp': instance.startDateTimeStamp,
      'EndDateTimeStamp': instance.endDateTimeStamp,
      'lstQuestion': instance.lstQuestion?.map((e) => e.toJson()).toList(),
    };

LstQuestion _$LstQuestionFromJson(Map json) => LstQuestion(
      questionDesc: json['QuestionDesc'] as String?,
      questionTypeID: json['QuestionTypeID'] as int?,
      optionType: json['OptionType'] as String?,
      lstOptions: (json['lstOptions'] as List<dynamic>?)
          ?.map((e) => LstOptions.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$LstQuestionToJson(LstQuestion instance) =>
    <String, dynamic>{
      'QuestionDesc': instance.questionDesc,
      'QuestionTypeID': instance.questionTypeID,
      'OptionType': instance.optionType,
      'lstOptions': instance.lstOptions?.map((e) => e.toJson()).toList(),
    };

LstOptions _$LstOptionsFromJson(Map json) => LstOptions(
      optionDesc: json['OptionDesc'] as String?,
    );

Map<String, dynamic> _$LstOptionsToJson(LstOptions instance) =>
    <String, dynamic>{
      'OptionDesc': instance.optionDesc,
    };

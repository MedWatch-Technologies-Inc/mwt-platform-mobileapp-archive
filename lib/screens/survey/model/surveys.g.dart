// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surveys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Surveys _$SurveysFromJson(Map json) => Surveys(
      json['Result'] as bool,
      json['Response'] as int,
      (json['Data'] is List)?(json['Data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList():[],
    );

Map<String, dynamic> _$SurveysToJson(Surveys instance) => <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

Data _$DataFromJson(Map json) => Data(
      json['SurveyGUID'] as String?,
      json['SurveyID'] as int,
      json['SurveyName'] as String,
      json['Startdate'] as String?,
      json['Enddate'] as String?,
      json['CreatedDatetime'] as String,
      json['TotalRecords'] as int?,
      json['PageNumber'] as int?,
      json['PageSize'] as int?,
      (json['lstQuestion'] as List<dynamic>?)
          ?.map(
              (e) => LstQuestion.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      json['SharedDate'] as String?,
      json['IsAnswerGiven'] as bool?,
      json['IsShared'] as bool?,
      json['PhysicalUrl'] as String?,
      json['FullName'] as String,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'SurveyID': instance.surveyID,
      'SurveyName': instance.surveyName,
      'Startdate': instance.startdate,
      'Enddate': instance.enddate,
      'CreatedDatetime': instance.createdDatetime,
      'TotalRecords': instance.totalRecords,
      'PageNumber': instance.pageNumber,
      'PageSize': instance.pageSize,
      'lstQuestion': instance.lstQuestion?.map((e) => e.toJson()).toList(),
      'SharedDate': instance.sharedDate,
      'IsAnswerGiven': instance.isAnswerGiven,
      'IsShared': instance.isShared,
      'PhysicalUrl': instance.physicalUrl,
      'FullName': instance.fullName,
      'SurveyGUID': instance.surveyGUID,
    };

LstQuestion _$LstQuestionFromJson(Map json) => LstQuestion(
      json['QuestionID'] as int,
      json['FKSurveyID'] as int,
      json['FKUserID'] as int,
      json['QuestionDesc'] as String,
      json['QuestionTypeID'] as int,
      json['OptionType'] as String,
      json['IsAnswerGiven'] as bool?,
      json['CreatedDatetime'] as String?,
      json['TotalRecords'] as int?,
      json['PageNumber'] as int?,
      json['PageSize'] as int?,
      (json['lstOptions'] as List<dynamic>?)
          ?.map((e) => LstOptions.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      json['lstAnswers'] as List<dynamic>?,
    );

Map<String, dynamic> _$LstQuestionToJson(LstQuestion instance) =>
    <String, dynamic>{
      'QuestionID': instance.questionID,
      'FKSurveyID': instance.fKSurveyID,
      'FKUserID': instance.fKUserID,
      'QuestionDesc': instance.questionDesc,
      'QuestionTypeID': instance.questionTypeID,
      'OptionType': instance.optionType,
      'IsAnswerGiven': instance.isAnswerGiven,
      'CreatedDatetime': instance.createdDatetime,
      'TotalRecords': instance.totalRecords,
      'PageNumber': instance.pageNumber,
      'PageSize': instance.pageSize,
      'lstOptions': instance.lstOptions?.map((e) => e.toJson()).toList(),
      'lstAnswers': instance.lstAnswers,
    };

LstOptions _$LstOptionsFromJson(Map json) => LstOptions(
      json['OptionID'] as int,
      json['FKSurveyID'] as int,
      json['FKQuestionID'] as int,
      json['OptionDesc'] as String,
    );

Map<String, dynamic> _$LstOptionsToJson(LstOptions instance) =>
    <String, dynamic>{
      'OptionID': instance.optionID,
      'FKSurveyID': instance.fKSurveyID,
      'FKQuestionID': instance.fKQuestionID,
      'OptionDesc': instance.optionDesc,
    };

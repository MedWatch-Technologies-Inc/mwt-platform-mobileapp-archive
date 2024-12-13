// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyDetail _$SurveyDetailFromJson(Map json) => SurveyDetail(
      json['Result'] as bool,
      json['Response'] as int,
      Data.fromJson(Map<String, dynamic>.from(json['Data'] as Map)),
    );

Map<String, dynamic> _$SurveyDetailToJson(SurveyDetail instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data.toJson(),
    };

Data _$DataFromJson(Map json) => Data(
      json['SurveyID'] as int,
      json['SurveyGUID'] as String?,
      json['SurveyName'] as String,
      json['FKUserID'] as int,
      json['Startdate'] as String?,
      json['Enddate'] as String?,
      json['CreatedDatetime'] as String,
      (json['lstQuestion'] as List<dynamic>)
          .map((e) => LstQuestion.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      json['PhysicalUrl'] as String?,
      json['SharedDate'] as String?,
      json['IsAnswerGiven'] as bool?,
      json['IsShared'] as bool?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'SurveyID': instance.surveyID,
      'SurveyGUID': instance.surveyGUID,
      'SurveyName': instance.surveyName,
      'FKUserID': instance.fKUserID,
      'Startdate': instance.startdate,
      'Enddate': instance.enddate,
      'CreatedDatetime': instance.createdDatetime,
      'lstQuestion': instance.lstQuestion.map((e) => e.toJson()).toList(),
      'PhysicalUrl': instance.physicalUrl,
      'SharedDate': instance.sharedDate,
      'IsAnswerGiven': instance.isAnswerGiven,
      'IsShared': instance.isShared,
    };

LstQuestion _$LstQuestionFromJson(Map json) => LstQuestion(
      json['QuestionID'] as int,
      json['FKSurveyID'] as int,
      json['FKUserID'] as int,
      json['QuestionDesc'] as String,
      json['QuestionTypeID'] as int,
      json['OptionType'] as String,
      json['IsAnswerGiven'] as bool,
      json['CreatedDatetime'] as String,
      json['TotalRecords'] as int?,
      json['PageNumber'] as int?,
      json['PageSize'] as int?,
      (json['lstOptions'] as List<dynamic>)
          .map((e) => LstOptions.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      json['lstAnswers'] as List<dynamic>,
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

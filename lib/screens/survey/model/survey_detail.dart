import 'package:json_annotation/json_annotation.dart';

part 'survey_detail.g.dart';


@JsonSerializable()
class SurveyDetail{

  @JsonKey(name: 'Result')
  bool result;

  @JsonKey(name: 'Response')
  int response;

  @JsonKey(name: 'Data')
  Data data;

  SurveyDetail(this.result,this.response,this.data,);

  factory SurveyDetail.fromJson(Map<String, dynamic> srcJson) => _$SurveyDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SurveyDetailToJson(this);

}


@JsonSerializable()
class Data {

  @JsonKey(name: 'SurveyID')
  int surveyID;

  @JsonKey(name: 'SurveyGUID')
  String? surveyGUID;

  @JsonKey(name: 'SurveyName')
  String surveyName;

  @JsonKey(name: 'FKUserID')
  int fKUserID;

  @JsonKey(name: 'Startdate')
  String? startdate;

  @JsonKey(name: 'Enddate')
  String? enddate;

  @JsonKey(name: 'CreatedDatetime')
  String createdDatetime;

  @JsonKey(name: 'lstQuestion')
  List<LstQuestion> lstQuestion;

  @JsonKey(name: 'PhysicalUrl')
  String? physicalUrl;

  @JsonKey(name: 'SharedDate')
  String? sharedDate;

  @JsonKey(name: 'IsAnswerGiven')
  bool? isAnswerGiven;

  @JsonKey(name: 'IsShared')
  bool? isShared;

  Data(this.surveyID,this.surveyGUID,this.surveyName,this.fKUserID,this.startdate,this.enddate,this.createdDatetime,this.lstQuestion,this.physicalUrl,this.sharedDate,this.isAnswerGiven,this.isShared,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}


@JsonSerializable()
class LstQuestion {

  @JsonKey(name: 'QuestionID')
  int questionID;

  @JsonKey(name: 'FKSurveyID')
  int fKSurveyID;

  @JsonKey(name: 'FKUserID')
  int fKUserID;

  @JsonKey(name: 'QuestionDesc')
  String questionDesc;

  @JsonKey(name: 'QuestionTypeID')
  int questionTypeID;

  @JsonKey(name: 'OptionType')
  String optionType;

  @JsonKey(name: 'IsAnswerGiven')
  bool isAnswerGiven;

  @JsonKey(name: 'CreatedDatetime')
  String createdDatetime;

  @JsonKey(name: 'TotalRecords')
  int? totalRecords;

  @JsonKey(name: 'PageNumber')
  int? pageNumber;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'lstOptions')
  List<LstOptions>? lstOptions;

  @JsonKey(name: 'lstAnswers')
  List<dynamic>? lstAnswers;

  LstQuestion(this.questionID,this.fKSurveyID,this.fKUserID,this.questionDesc,this.questionTypeID,this.optionType,this.isAnswerGiven,this.createdDatetime,this.totalRecords,this.pageNumber,this.pageSize,this.lstOptions,this.lstAnswers,);

  factory LstQuestion.fromJson(Map<String, dynamic> srcJson) => _$LstQuestionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LstQuestionToJson(this);

}


@JsonSerializable()
class LstOptions  {

  @JsonKey(name: 'OptionID')
  int optionID;

  @JsonKey(name: 'FKSurveyID')
  int fKSurveyID;

  @JsonKey(name: 'FKQuestionID')
  int fKQuestionID;

  @JsonKey(name: 'OptionDesc')
  String optionDesc;

  LstOptions(this.optionID,this.fKSurveyID,this.fKQuestionID,this.optionDesc,);

  factory LstOptions.fromJson(Map<String, dynamic> srcJson) => _$LstOptionsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LstOptionsToJson(this);

}




import 'package:json_annotation/json_annotation.dart';

part 'create_survey_model.g.dart';

@JsonSerializable()
class CreateSurveyModel {
  CreateSurveyModel({
      this.surveyName, 
      this.fKUserID, 
      this.startDateTimeStamp, 
      this.endDateTimeStamp, 
      this.lstQuestion,});

  factory CreateSurveyModel.fromJson(dynamic json) => _$CreateSurveyModelFromJson(json);


  @JsonKey(name: 'SurveyName')
  String? surveyName;
  @JsonKey(name: 'FKUserID')
  int? fKUserID;
  @JsonKey(name: 'StartDateTimeStamp')
  String? startDateTimeStamp;
  @JsonKey(name: 'EndDateTimeStamp')
  String? endDateTimeStamp;
  @JsonKey(name: 'lstQuestion')
  List<LstQuestion>? lstQuestion;

  Map<String, dynamic> toJson() => _$CreateSurveyModelToJson(this);

}

@JsonSerializable()
class LstQuestion {
  LstQuestion({
      this.questionDesc, 
      this.questionTypeID, 
      this.optionType, 
      this.lstOptions,});

  factory LstQuestion.fromJson(dynamic json) => _$LstQuestionFromJson(json);


  @JsonKey(name: 'QuestionDesc')
  String? questionDesc;
  @JsonKey(name: 'QuestionTypeID')
  int? questionTypeID;
  @JsonKey(name: 'OptionType')
  String? optionType;
  @JsonKey(name: 'lstOptions')
  List<LstOptions>? lstOptions;

  Map<String, dynamic> toJson() => _$LstQuestionToJson(this);

}

@JsonSerializable()
class LstOptions {
  LstOptions({
      this.optionDesc,});

  factory LstOptions.fromJson(dynamic json) => _$LstOptionsFromJson(json);
  @JsonKey(name: 'OptionDesc')
  String? optionDesc;

  Map<String, dynamic> toJson() => _$LstOptionsToJson(this);

}
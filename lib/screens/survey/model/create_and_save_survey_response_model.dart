
import 'package:json_annotation/json_annotation.dart';

part 'create_and_save_survey_response_model.g.dart';

@JsonSerializable()
class CreateAndSaveSurveyResponseModel {
  CreateAndSaveSurveyResponseModel({
      this.result, 
      this.id, 
      this.response, 
      this.message,});

  factory CreateAndSaveSurveyResponseModel.fromJson(dynamic json) => _$CreateAndSaveSurveyResponseModelFromJson(json);

  @JsonKey(name: 'Result')
  bool? result;
  @JsonKey(name:'ID' )
  int? id;
  @JsonKey(name: 'Response')
  int? response;
  @JsonKey(name: 'Message')
  String? message;

  Map<String, dynamic> toJson() =>_$CreateAndSaveSurveyResponseModelToJson(this);

}
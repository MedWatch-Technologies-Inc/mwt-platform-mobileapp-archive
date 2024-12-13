
import 'package:json_annotation/json_annotation.dart';

part 'share_survey_response_model.g.dart';

@JsonSerializable()
class ShareSurveyResponseModel {
  ShareSurveyResponseModel({
    this.result,
    this.response,
    this.message,});

  factory ShareSurveyResponseModel.fromJson(dynamic json) => _$ShareSurveyResponseModelFromJson(json);

  @JsonKey(name: 'Result')
  bool? result;
  @JsonKey(name: 'Response')
  int? response;
  @JsonKey(name: 'Message')
  String? message;

  Map<String, dynamic> toJson() =>_$ShareSurveyResponseModelToJson(this);

}
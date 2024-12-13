import 'package:json_annotation/json_annotation.dart';

part 'share_survey_with_contacts_request_body.g.dart';


@JsonSerializable()
class ShareSurveyWithContactsRequestBody{

  @JsonKey(name: 'FKUserID')
  int fkUserID;

  @JsonKey(name: 'StartDateTimeStamp')
  String? startDateDateStamp;

  @JsonKey(name: 'ShredUserIDList')
  String? sharedUserIdList;

  @JsonKey(name: 'SurveyID')
  int surveyId;

  @JsonKey(name: 'PhysicalUrl')
  String? physicalUrl;

  ShareSurveyWithContactsRequestBody(this.fkUserID,this.surveyId,this.sharedUserIdList,this.physicalUrl,this.startDateDateStamp);

  factory ShareSurveyWithContactsRequestBody.fromJson(Map<String, dynamic> srcJson) => _$ShareSurveyWithContactsRequestBodyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ShareSurveyWithContactsRequestBodyToJson(this);

}



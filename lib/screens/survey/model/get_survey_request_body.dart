import 'package:json_annotation/json_annotation.dart';

part 'get_survey_request_body.g.dart';


@JsonSerializable()
class GetSurveysRequestBody{

  @JsonKey(name: 'UserID')
  int userID;

  @JsonKey(name: 'FromDateStamp')
  String? fromDateStamp;

  @JsonKey(name: 'ToDateStamp')
  String? toDateStamp;

  @JsonKey(name: 'PageIndex')
  int pageIndex;

  @JsonKey(name: 'PageSize')
  int pageSize;

  GetSurveysRequestBody(this.userID,this.fromDateStamp,this.toDateStamp,this.pageIndex,this.pageSize,);

  factory GetSurveysRequestBody.fromJson(Map<String, dynamic> srcJson) => _$GetSurveysRequestBodyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetSurveysRequestBodyToJson(this);

}



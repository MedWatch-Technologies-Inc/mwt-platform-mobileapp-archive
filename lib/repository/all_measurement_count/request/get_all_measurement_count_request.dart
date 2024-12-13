import 'package:json_annotation/json_annotation.dart';

part 'get_all_measurement_count_request.g.dart';


@JsonSerializable()
class GetAllMeasurementCountRequest extends Object {

  @JsonKey(name: 'UserId')
  String? userId;

  @JsonKey(name: 'FromDateStamp')
  String? fromDateStamp;

  @JsonKey(name: 'ToDateStamp')
  String? toDateStamp;

  GetAllMeasurementCountRequest({this.userId,this.fromDateStamp,this.toDateStamp});

  factory GetAllMeasurementCountRequest.fromJson(Map<String, dynamic> srcJson) => _$GetAllMeasurementCountRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetAllMeasurementCountRequestToJson(this);

}



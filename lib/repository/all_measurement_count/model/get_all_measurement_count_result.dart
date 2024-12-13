import 'package:json_annotation/json_annotation.dart';

part 'get_all_measurement_count_result.g.dart';


@JsonSerializable()
class GetAllMeasurementCountResult extends Object {

  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  AllMeasurementCount? allMeasurementCount;

  GetAllMeasurementCountResult({this.result,this.response,this.allMeasurementCount});

  factory GetAllMeasurementCountResult.fromJson(Map<String, dynamic> srcJson) => _$GetAllMeasurementCountResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetAllMeasurementCountResultToJson(this);

}


@JsonSerializable()
class AllMeasurementCount extends Object {

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'MeasurementCount')
  int? measurementCount;

  @JsonKey(name: 'WorkActivityCount')
  int? workActivityCount;

  @JsonKey(name: 'SleepActivityCount')
  int? sleepActivityCount;

  @JsonKey(name: 'WeightScaleCount')
  int? weightScaleCount;

  @JsonKey(name: 'TagHistoryCount')
  int? tagHistoryCount;

  @JsonKey(name: 'TagLabelCount')
  int? tagLabelCount;

  @JsonKey(name: 'ContactCount')
  int? contactCount;

  @JsonKey(name: 'UserVitalStatusCount')
  int? userVitalStatusCount;

  AllMeasurementCount(this.userID,this.measurementCount,this.workActivityCount,this.sleepActivityCount,this.weightScaleCount,this.tagHistoryCount,this.tagLabelCount,this.contactCount,this.userVitalStatusCount,);

  factory AllMeasurementCount.fromJson(Map<String, dynamic> srcJson) => _$AllMeasurementCountFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AllMeasurementCountToJson(this);

}



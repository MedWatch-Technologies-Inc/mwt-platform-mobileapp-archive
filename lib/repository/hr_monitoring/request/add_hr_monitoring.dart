import 'package:json_annotation/json_annotation.dart';

part 'add_hr_monitoring.g.dart';


@JsonSerializable()
class AddHrMonitoring extends Object {

  @JsonKey(name: 'userId')
  int userId;

  @JsonKey(name: 'hrData')
  List<HrData> hrData;

  @JsonKey(name: 'idForApi')
  int idForApi;

  AddHrMonitoring(this.userId,this.hrData,this.idForApi,);

  factory AddHrMonitoring.fromJson(Map<String, dynamic> srcJson) => _$AddHrMonitoringFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddHrMonitoringToJson(this);

}


@JsonSerializable()
class HrData extends Object {

  @JsonKey(name: 'date')
  String date;

  @JsonKey(name: 'hr')
  int hr;

  HrData(this.date,this.hr,);

  factory HrData.fromJson(Map<String, dynamic> srcJson) => _$HrDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HrDataToJson(this);

}

  

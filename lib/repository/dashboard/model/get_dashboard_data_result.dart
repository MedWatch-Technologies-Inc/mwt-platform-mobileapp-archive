import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_dashboard_data_result.g.dart';

@JsonSerializable()
class GetDashboardDataResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'SleepData')
  SleepInfoModel? sleepInfoModel;

  @JsonKey(name: 'WeightDetails')
  WeightMeasurementModel? weightMeasurementModel;

  @JsonKey(name: 'ActivityDetails')
  MotionInfoModel? motionInfoModel;

  @JsonKey(name: 'MesurmentDetails')
  MeasurementHistoryModel? measurementHistoryModel;

  @JsonKey(name: 'UserVitalStatus')
  List<TempModel>? tempModel;

  GetDashboardDataResult({
    this.result,
    this.motionInfoModel,
    this.weightMeasurementModel,
    this.measurementHistoryModel,
    this.sleepInfoModel,
    this.tempModel,
  });

  factory GetDashboardDataResult.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDashboardDataResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetDashboardDataResultToJson(this);
}

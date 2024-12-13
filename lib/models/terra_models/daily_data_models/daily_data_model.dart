import 'package:health_gauge/models/terra_models/daily_data_models/active_duration_data.dart';
import 'package:health_gauge/models/terra_models/daily_data_models/calories_data.dart';
import 'package:health_gauge/models/terra_models/daily_data_models/met_data.dart';

class DailyDataModel {
  METData metData;
  ActiveDurationData activeDurationData;
  CaloriesData caloriesData;

  DailyDataModel({
    required this.metData,
    required this.activeDurationData,
    required this.caloriesData,
  });

  factory DailyDataModel.fromJson(Map<String, dynamic> json) {
    return DailyDataModel(
      metData: METData.fromJson(json['MET_data']),
      activeDurationData:
      ActiveDurationData.fromJson(json['active_durations_data']),
      caloriesData: CaloriesData.fromJson(json['calories_data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MET_data': metData,
      'active_durations_data': activeDurationData,
      'calories_data': caloriesData,
    };
  }
}
import 'package:health_gauge/utils/json_serializable_utils.dart';

class CaloriesData {
  num bmrCalories;
  num netActivityCalories;
  num netIntakeCalories;
  num totalBurnedCalories;

  CaloriesData({
    required this.bmrCalories,
    required this.netActivityCalories,
    required this.netIntakeCalories,
    required this.totalBurnedCalories,
  });

  factory CaloriesData.fromJson(Map<String, dynamic> json) {
    return CaloriesData(
      bmrCalories:
      JsonSerializableUtils.instance.checkNum(json['BMR_calories']),
      netActivityCalories: JsonSerializableUtils.instance
          .checkNum(json['net_activity_calories']),
      netIntakeCalories:
      JsonSerializableUtils.instance.checkNum(json['net_intake_calories']),
      totalBurnedCalories: JsonSerializableUtils.instance
          .checkNum(json['total_burned_calories']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BMR_calories': bmrCalories,
      'net_activity_calories': netActivityCalories,
      'net_intake_calories': netIntakeCalories,
      'total_burned_calories': totalBurnedCalories,
    };
  }

//
}
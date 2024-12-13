import 'package:health_gauge/utils/json_serializable_utils.dart';

class ActiveDurationData {
  List<ActivityLevelSample> activityLevelSamples;
  num activitySeconds;
  num inactivitySeconds;
  num lowIntensitySeconds;
  num moderateIntensitySeconds;
  int numContinuousInactivePeriods;
  num restSeconds;
  num vigorousIntensitySeconds;

  ActiveDurationData({
    required this.activityLevelSamples,
    required this.activitySeconds,
    required this.inactivitySeconds,
    required this.lowIntensitySeconds,
    required this.moderateIntensitySeconds,
    required this.numContinuousInactivePeriods,
    required this.restSeconds,
    required this.vigorousIntensitySeconds,
  });

  factory ActiveDurationData.fromJson(Map<String, dynamic> json) {
    return ActiveDurationData(
      activityLevelSamples: json['activity_levels_samples'] != null
          ? (json['activity_levels_samples'] as List)
          .map((e) => ActivityLevelSample.fromJson(e))
          .toList()
          : [],
      activitySeconds:
      JsonSerializableUtils.instance.checkNum(json['activity_seconds']),
      inactivitySeconds:
      JsonSerializableUtils.instance.checkNum(json['inactivity_seconds']),
      lowIntensitySeconds: JsonSerializableUtils.instance
          .checkNum(json['low_intensity_seconds']),
      moderateIntensitySeconds: JsonSerializableUtils.instance
          .checkNum(json['moderate_intensity_seconds']),
      numContinuousInactivePeriods: JsonSerializableUtils.instance
          .checkInt(json['num_continuous_inactive_periods']),
      restSeconds:
      JsonSerializableUtils.instance.checkNum(json['rest_seconds']),
      vigorousIntensitySeconds: JsonSerializableUtils.instance
          .checkNum(json['vigorous_intensity_seconds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_levels_samples':
      activityLevelSamples.map((e) => e.toJson()).toList(),
      'activity_seconds': activitySeconds,
      'inactivity_seconds': inactivitySeconds,
      'low_intensity_seconds': lowIntensitySeconds,
      'moderate_intensity_seconds': moderateIntensitySeconds,
      'num_continuous_inactive_periods': numContinuousInactivePeriods,
      'rest_seconds': restSeconds,
      'vigorous_intensity_seconds': vigorousIntensitySeconds,
    };
  }
}

class ActivityLevelSample {
  int activityLevel;
  String timestamp;

  ActivityLevelSample({
    required this.activityLevel,
    required this.timestamp,
  });

  factory ActivityLevelSample.fromJson(Map<String, dynamic> json) {
    return ActivityLevelSample(
      activityLevel:
      JsonSerializableUtils.instance.checkInt(json['activity_level']),
      timestamp: JsonSerializableUtils.instance.checkString(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_level': activityLevel,
      'timestamp': timestamp,
    };
  }
}
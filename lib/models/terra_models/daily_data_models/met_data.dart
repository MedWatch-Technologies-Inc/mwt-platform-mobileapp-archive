import 'package:health_gauge/utils/json_serializable_utils.dart';

class METData {
  List<METSample> sampleList;
  num avgLevel;
  num numHighIntensityMinutes;
  num numInactiveMinutes;
  num numLowIntensityMinutes;
  num numModerateIntensityMinutes;

  METData({
    required this.sampleList,
    required this.avgLevel,
    required this.numHighIntensityMinutes,
    required this.numInactiveMinutes,
    required this.numLowIntensityMinutes,
    required this.numModerateIntensityMinutes,
  });

  factory METData.fromJson(Map<String, dynamic> json) {
    return METData(
      sampleList: json['samples'] != null
          ? (json['samples'] as List).map((e) => METSample.fromJson(e)).toList()
          : [],
      avgLevel: JsonSerializableUtils.instance.checkNum(json['avg_level']),
      numHighIntensityMinutes: JsonSerializableUtils.instance
          .checkNum(json['num_high_intensity_minutes']),
      numInactiveMinutes:
      JsonSerializableUtils.instance.checkNum(json['num_inactive_minutes']),
      numLowIntensityMinutes: JsonSerializableUtils.instance
          .checkNum(json['num_low_intensity_minutes']),
      numModerateIntensityMinutes: JsonSerializableUtils.instance
          .checkNum(json['num_moderate_intensity_minutes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'samples': sampleList.map((e) => e.toJson()).toList(),
      'avg_level': avgLevel,
      'num_high_intensity_minutes': numHighIntensityMinutes,
      'num_inactive_minutes': numInactiveMinutes,
      'num_low_intensity_minutes': numLowIntensityMinutes,
      'num_moderate_intensity_minutes': numModerateIntensityMinutes,
    };
  }
}

class METSample {
  num level;
  String timestamp;

  METSample({
    required this.level,
    required this.timestamp,
  });

  factory METSample.fromJson(Map<String, dynamic> json) {
    return METSample(
      level: JsonSerializableUtils.instance.checkNum(json['level']),
      timestamp: JsonSerializableUtils.instance.checkString(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'timestamp': timestamp,
    };
  }
}
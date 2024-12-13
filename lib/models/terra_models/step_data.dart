import 'package:health_gauge/utils/date_utils.dart';
class StepModel {
  StepModel({
      this.timestamp, 
      this.steps, 
      this.timerDurationSeconds,});

  StepModel.fromJson(dynamic json) {
    timestamp = DateUtil.parse(json['timestamp']);
    steps = json['steps'];
    timerDurationSeconds = json['timer_duration_seconds'];
  }
  DateTime? timestamp;
  num? steps;
  num? timerDurationSeconds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp;
    map['steps'] = steps;
    map['timer_duration_seconds'] = timerDurationSeconds;
    return map;
  }

}
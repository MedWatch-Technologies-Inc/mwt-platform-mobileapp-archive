import 'package:health_gauge/utils/date_utils.dart';

class DistanceModel {
  DistanceModel({
      this.timestamp, 
      this.distanceMeters, 
      this.timerDurationSeconds,});

  DistanceModel.fromJson(dynamic json) {
    timestamp = DateUtil.parse(json['timestamp']);
    distanceMeters = json['distance_meters'];
    timerDurationSeconds = json['timer_duration_seconds'];
  }
  DateTime? timestamp;
  num? distanceMeters;
  num? timerDurationSeconds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp;
    map['distance_meters'] = distanceMeters;
    map['timer_duration_seconds'] = timerDurationSeconds;
    return map;
  }


}
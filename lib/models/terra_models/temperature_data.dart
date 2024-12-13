import 'package:health_gauge/utils/date_utils.dart';
class TemperatureModel {
  TemperatureModel({
      this.timestamp, 
      this.temperatureCelsius,});

  TemperatureModel.fromJson(dynamic json) {
    timestamp = DateUtil.parse(json['timestamp']);
    temperatureCelsius = json['temperature_celsius'];
  }
  DateTime? timestamp;
  num? temperatureCelsius;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp.toString();
    map['temperature_celsius'] = temperatureCelsius;
    return map;
  }

}
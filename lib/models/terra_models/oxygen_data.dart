import 'package:health_gauge/utils/date_utils.dart';
class OxygenModel {
  OxygenModel({
      this.timestamp, 
      this.percentage,});

  OxygenModel.fromJson(dynamic json) {
    timestamp = DateUtil.parse(json['timestamp']);

    percentage = json['percentage'];
  }
  DateTime? timestamp;
  num? percentage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp;
    map['percentage'] = percentage;
    return map;
  }

}
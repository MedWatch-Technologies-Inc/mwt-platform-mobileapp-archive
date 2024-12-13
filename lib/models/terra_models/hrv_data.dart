import 'package:health_gauge/utils/date_utils.dart';

class HrvModel {
  HrvModel({
    this.timestamp,
    this.hrvRmssd,
    this.hrvSdnn,
  });

  HrvModel.fromJson(dynamic json) {
    timestamp = DateUtil.parse(json['timestamp']);
    hrvRmssd = json['hrv_rmssd'];
    hrvSdnn = json['hrv_sdnn'];
  }

  DateTime? timestamp;
  num? hrvRmssd;
  num? hrvSdnn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp;
    map['hrv_rmssd'] = hrvRmssd;
    map['hrv_sdnn'] = hrvSdnn;
    return map;
  }

  num get hrv => hrvRmssd ?? hrvSdnn ?? 0;
}

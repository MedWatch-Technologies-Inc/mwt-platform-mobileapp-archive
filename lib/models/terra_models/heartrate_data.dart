import 'package:health_gauge/utils/date_utils.dart';
class HeartrateModel {
  HeartrateModel({
      this.timestamp, 
      this.bpm,});

  HeartrateModel.fromJson(dynamic json) {
    timestamp = DateUtil.parse(json['timestamp']);

    bpm = json['bpm'];
  }
  DateTime? timestamp;
  num? bpm;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp;
    map['bpm'] = bpm;
    return map;
  }

}
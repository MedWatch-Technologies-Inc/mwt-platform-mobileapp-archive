import 'package:health_gauge/utils/date_utils.dart';
class GlucoseModel {
  GlucoseModel({
      this.timestamp, 
      this.bloodGlucoseMgPerDL, 
      this.glucoseLevelFlag, 
      this.trendArrow,});

  GlucoseModel.fromJson(dynamic json) {
    timestamp = DateUtil.parse(json['timestamp']);

    bloodGlucoseMgPerDL = json['blood_glucose_mg_per_dL'];
    glucoseLevelFlag = json['glucose_level_flag'];
    trendArrow = json['trend_arrow'];
  }
  DateTime? timestamp;
  num? bloodGlucoseMgPerDL;
  num? glucoseLevelFlag;
  num? trendArrow;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp;
    map['blood_glucose_mg_per_dL'] = bloodGlucoseMgPerDL;
    map['glucose_level_flag'] = glucoseLevelFlag;
    map['trend_arrow'] = trendArrow;
    return map;
  }

}
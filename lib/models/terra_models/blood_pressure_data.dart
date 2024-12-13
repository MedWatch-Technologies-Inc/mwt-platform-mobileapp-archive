import 'package:health_gauge/utils/date_utils.dart';

class BloodPressureModel {
  BloodPressureModel({
    this.timestamp,
    this.diastolicBp,
    this.systolicBp,
  });

  BloodPressureModel.fromJson(dynamic json) {
    timestamp = DateUtil.parse(json['timestamp']);
    diastolicBp = json['diastolic_bp'];
    systolicBp = json['systolic_bp'];
  }

  DateTime? timestamp;
  num? diastolicBp;
  num? systolicBp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp;
    map['diastolic_bp'] = diastolicBp;
    map['systolic_bp'] = systolicBp;
    return map;
  }
}

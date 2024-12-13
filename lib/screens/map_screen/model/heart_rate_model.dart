import 'package:health_gauge/repository/activity_tracker/model/get_recognition_activity_list_result.dart';
import 'package:health_gauge/services/location/model/location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'heart_rate_model.g.dart';

@JsonSerializable()
class HeartRateModel extends Object {
  @JsonKey(name: 'hr')
  int? hr;

  @JsonKey(name: 'timeStamp')
  int? timeStamp;

  @JsonKey(name: 'speed')
  double? speed;

  @JsonKey(name: 'elevation')
  double? elevation;

  @JsonKey(name: 'locationData')
  LocationAddressModel? locationData;

  HeartRateModel({
    this.hr,
    this.timeStamp,
    this.speed,
    this.elevation,
    this.locationData,
  });

  factory HeartRateModel.fromJson(Map<String, dynamic> srcJson) =>
      _$HeartRateModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HeartRateModelToJson(this);

  static HeartRateModel mapper(HeartRate obj) {
    var model = HeartRateModel();
    model
      ..hr = obj.hR
      ..timeStamp = int.tryParse(obj.timeStamp!)
      ..speed = double.parse(obj.speed ?? '0.0')
      ..locationData = LocationAddressModel.mapper(obj.locationData!)
      ..elevation = double.parse(obj.elevation ?? '0.0');
    return model;
  }
}

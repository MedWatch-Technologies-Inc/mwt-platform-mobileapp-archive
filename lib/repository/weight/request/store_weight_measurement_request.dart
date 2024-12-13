import 'package:json_annotation/json_annotation.dart';

part 'store_weight_measurement_request.g.dart';

@JsonSerializable()
class StoreWeightMeasurementRequest extends Object {
  @JsonKey(name: 'userId')
  String? userId;

  @JsonKey(name: 'weightsum')
  double? weightSum;

  @JsonKey(name: 'bMI')
  double? bMI;

  @JsonKey(name: 'fatRate')
  double? fatRate;

  @JsonKey(name: 'muscle')
  double? muscle;

  @JsonKey(name: 'moisture')
  double? moisture;

  @JsonKey(name: 'boneMass')
  double? boneMass;

  @JsonKey(name: 'subcutaneousFat')
  double? subcutaneousFat;

  @JsonKey(name: 'bMR')
  double? bMR;

  @JsonKey(name: 'proteinRate')
  double? proteinRate;

  @JsonKey(name: 'visceralFat')
  double? visceralFat;

  @JsonKey(name: 'physicalAge')
  double? physicalAge;

  @JsonKey(name: 'standardWeight')
  double? standardWeight;

  @JsonKey(name: 'weightControl')
  double? weightControl;

  @JsonKey(name: 'fatMass')
  double? fatMass;

  @JsonKey(name: 'weightWithoutFat')
  double? weightWithoutFat;

  @JsonKey(name: 'muscleMass')
  double? muscleMass;

  @JsonKey(name: 'proteinMass')
  double? proteinMass;

  @JsonKey(name: 'fatlevel')
  int? fatLevel;

  @JsonKey(name: 'CreatedDateTime')
  String? createdDateTime;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  StoreWeightMeasurementRequest({
    this.userId,
    this.weightSum,
    this.bMI,
    this.createdDateTime,
    this.bMR,
    this.boneMass,
    this.fatLevel,
    this.fatMass,
    this.fatRate,
    this.moisture,
    this.muscle,
    this.muscleMass,
    this.physicalAge,
    this.proteinMass,
    this.proteinRate,
    this.standardWeight,
    this.subcutaneousFat,
    this.visceralFat,
    this.weightControl,
    this.weightWithoutFat,
    this.createdDateTimeStamp,
  });

  factory StoreWeightMeasurementRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$StoreWeightMeasurementRequestFromJson(srcJson);

  Map<String, dynamic> toJson() {
    var map = _$StoreWeightMeasurementRequestToJson(this);
    map.removeWhere((key, value) => value == null);
    return map;
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'set_measurement_unit_request.g.dart';

@JsonSerializable()
class SetMeasurementUnitRequest extends Object {
  @JsonKey(name: 'UnitData')
  List<SetMeasurementUnitData>? unitData;

  SetMeasurementUnitRequest({
    this.unitData,
  });

  factory SetMeasurementUnitRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$SetMeasurementUnitRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SetMeasurementUnitRequestToJson(this);
}

@JsonSerializable()
class SetMeasurementUnitData extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'Measurement')
  String? measurement;

  @JsonKey(name: 'Unit')
  String? unit;

  @JsonKey(name: 'Value')
  String? value;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  SetMeasurementUnitData({
    this.userID,
    this.measurement,
    this.unit,
    this.value,
    this.createdDateTimeStamp,
  });

  factory SetMeasurementUnitData.fromJson(Map<String, dynamic> srcJson) =>
      _$SetMeasurementUnitDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SetMeasurementUnitDataToJson(this);
}

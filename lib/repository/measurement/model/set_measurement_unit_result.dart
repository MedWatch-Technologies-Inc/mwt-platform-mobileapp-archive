import 'package:json_annotation/json_annotation.dart';

part 'set_measurement_unit_result.g.dart';

@JsonSerializable()
class SetMeasurementUnitResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'IDs')
  String? iD;

  SetMeasurementUnitResult({
    this.result,
    this.response,
    this.iD,
  });

  factory SetMeasurementUnitResult.fromJson(Map<String, dynamic> srcJson) =>
      _$SetMeasurementUnitResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SetMeasurementUnitResultToJson(this);
}

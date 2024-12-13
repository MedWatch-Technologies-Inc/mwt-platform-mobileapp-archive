import 'package:json_annotation/json_annotation.dart';

part 'store_weight_measurement_result.g.dart';

@JsonSerializable()
class StoreWeightMeasurementResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'ID')
  List<int>? iD;

  StoreWeightMeasurementResult({
    this.result,
    this.response,
    this.iD,
  });

  factory StoreWeightMeasurementResult.fromJson(Map<String, dynamic> srcJson) =>
      _$StoreWeightMeasurementResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreWeightMeasurementResultToJson(this);
}

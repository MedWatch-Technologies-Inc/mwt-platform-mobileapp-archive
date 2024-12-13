import 'package:json_annotation/json_annotation.dart';

part 'estimate_result.g.dart';

@JsonSerializable()
class EstimateResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'Data')
  String? data;

  @JsonKey(name: 'SBP')
  int? sBP;

  @JsonKey(name: 'DBP')
  int? dBP;

  @JsonKey(name: 'value')
  dynamic value;

  @JsonKey(name: 'BG')
  dynamic BG;

  @JsonKey(name: 'Uncertainty')
  dynamic Uncertainty;

  @JsonKey(name: 'BG1')
  dynamic BG1;

  @JsonKey(name: 'Unit')
  dynamic Unit;

  @JsonKey(name: 'Unit1')
  dynamic Unit1;

  @JsonKey(name: 'Class')
  dynamic Class;

  EstimateResult(
      {this.result,
      this.response,
      this.iD,
      this.data,
      this.sBP,
      this.dBP,
      this.value,
      this.BG,
      this.Uncertainty,
      this.BG1,
      this.Unit,
      this.Unit1,
      this.Class});

  factory EstimateResult.fromJson(Map<String, dynamic> srcJson) =>
      _$EstimateResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EstimateResultToJson(this);
}

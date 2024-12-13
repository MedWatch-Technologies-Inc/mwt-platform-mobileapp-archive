import 'package:json_annotation/json_annotation.dart';

part 'delete_estimate_result.g.dart';

@JsonSerializable()
class DeleteEstimateResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'ID')
  int? iD;

  DeleteEstimateResult({
    this.result,
    this.response,
    this.iD,
  });

  factory DeleteEstimateResult.fromJson(Map<String, dynamic> srcJson) =>
      _$DeleteEstimateResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DeleteEstimateResultToJson(this);
}

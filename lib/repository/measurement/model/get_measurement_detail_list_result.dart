
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_measurement_detail_list_result.g.dart';

@JsonSerializable()
class GetMeasurementDetailListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<MeasurementHistoryModel>? data;

  GetMeasurementDetailListResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetMeasurementDetailListResult.fromJson(
      Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetMeasurementDetailListResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetMeasurementDetailListResultToJson(this);
}

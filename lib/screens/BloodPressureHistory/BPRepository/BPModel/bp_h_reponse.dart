import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bp_h_reponse.g.dart';

@JsonSerializable()
class BPHistoryResponse extends Object {
  @JsonKey(name: 'Result')
  bool result;

  @JsonKey(name: 'Response')
  int response;

  @JsonKey(name: 'Data')
  List<BPHistoryModel> data;

  BPHistoryResponse(
    this.result,
    this.response,
    this.data,
  );

  factory BPHistoryResponse.fromJson(Map<String, dynamic> srcJson)
  {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetBPDataResponseFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetBPDataResponseToJson(this);
}

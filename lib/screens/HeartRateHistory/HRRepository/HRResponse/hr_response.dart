import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_model.dart';
import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hr_response.g.dart';

@JsonSerializable()
class HRResponse extends Object {
  @JsonKey(name: 'Result')
  bool result;

  @JsonKey(name: 'Response')
  int response;

  @JsonKey(name: 'Data')
  List<SyncHRModel> data;

  HRResponse(
      this.result,
      this.response,
      this.data,
      );

  factory HRResponse.fromJson(Map<String, dynamic> srcJson)
  {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetHRResponseFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetHRResponseToJson(this);
}

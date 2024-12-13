import 'package:health_gauge/models/temp_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_user_vital_status_result.g.dart';

@JsonSerializable()
class GetUserVitalStatusResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<TempModel>? data;

  GetUserVitalStatusResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetUserVitalStatusResult.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetUserVitalStatusResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetUserVitalStatusResultToJson(this);
}

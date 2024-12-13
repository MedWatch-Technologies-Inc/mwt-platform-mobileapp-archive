import 'package:json_annotation/json_annotation.dart';

part 'save_user_vital_status_result.g.dart';

@JsonSerializable()
class SaveUserVitalStatusResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'ID')
  List<dynamic>? iD;

  SaveUserVitalStatusResult({
    this.result,
    this.response,
    this.iD,
  });

  factory SaveUserVitalStatusResult.fromJson(Map<String, dynamic> srcJson) =>
      _$SaveUserVitalStatusResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SaveUserVitalStatusResultToJson(this);
}

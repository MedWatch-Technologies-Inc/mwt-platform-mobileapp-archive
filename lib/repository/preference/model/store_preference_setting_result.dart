import 'package:json_annotation/json_annotation.dart';

part 'store_preference_setting_result.g.dart';

@JsonSerializable()
class StorePreferenceSettingResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  StorePreferenceSettingResult({
    this.result,
    this.response,
    this.message,
  });

  factory StorePreferenceSettingResult.fromJson(Map<String, dynamic> srcJson) =>
      _$StorePreferenceSettingResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StorePreferenceSettingResultToJson(this);
}

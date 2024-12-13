import 'package:health_gauge/screens/device_management/model/device_setting_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_device_settings_result.g.dart';

@JsonSerializable()
class GetDeviceSettingResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  DeviceSettingModel? data;

  GetDeviceSettingResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetDeviceSettingResult.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDeviceSettingResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetDeviceSettingResultToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'store_device_info_result.g.dart';

@JsonSerializable()
class StoreDeviceInfoResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'Message')
  String? message;

  StoreDeviceInfoResult({
    this.result,
    this.response,
    this.iD,
    this.message,
  });

  factory StoreDeviceInfoResult.fromJson(Map<String, dynamic> srcJson) =>
      _$StoreDeviceInfoResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreDeviceInfoResultToJson(this);
}

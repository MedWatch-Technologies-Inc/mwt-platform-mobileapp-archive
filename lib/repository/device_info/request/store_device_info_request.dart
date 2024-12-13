import 'package:json_annotation/json_annotation.dart';

part 'store_device_info_request.g.dart';

@JsonSerializable()
class StoreDeviceInfoRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'DeviceName')
  String? deviceName;

  @JsonKey(name: 'DeviceAddress')
  String? deviceAddress;

  @JsonKey(name: 'BlockStatus')
  String? blockStatus;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'CreatedDateTimeStamp')
  int? createdDateTimeStamp;

  StoreDeviceInfoRequest({
    this.userID,
    this.iD,
    this.blockStatus,
    this.deviceAddress,
    this.deviceName,
    this.createdDateTimeStamp,
  });

  factory StoreDeviceInfoRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$StoreDeviceInfoRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreDeviceInfoRequestToJson(this);
}

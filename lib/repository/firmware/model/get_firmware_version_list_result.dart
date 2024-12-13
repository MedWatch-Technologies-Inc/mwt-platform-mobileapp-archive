import 'package:json_annotation/json_annotation.dart';

part 'get_firmware_version_list_result.g.dart';

@JsonSerializable()
class GetFirmwareVersionListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Data')
  List<GetFirmwareVersionListData>? data;

  GetFirmwareVersionListResult({
    this.result,
    this.data,
  });

  factory GetFirmwareVersionListResult.fromJson(Map<String, dynamic> srcJson) =>
      _$GetFirmwareVersionListResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetFirmwareVersionListResultToJson(this);
}

@JsonSerializable()
class GetFirmwareVersionListData extends Object {
  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'VersionNo')
  String? versionNo;

  @JsonKey(name: 'Versionname')
  String? versionname;

  @JsonKey(name: 'Dateofuploading')
  String? dateofuploading;

  @JsonKey(name: 'Description')
  String? description;

  @JsonKey(name: 'Downloadurl')
  String? downloadurl;

  @JsonKey(name: 'fk_FirmwareTypeId')
  int? fkFirmwareTypeId;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'PageNumber')
  int? pageNumber;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'TotalRecords')
  int? totalRecords;

  @JsonKey(name: 'FirmwareType')
  String? firmwareType;

  GetFirmwareVersionListData({
    this.iD,
    this.versionNo,
    this.versionname,
    this.dateofuploading,
    this.description,
    this.downloadurl,
    this.fkFirmwareTypeId,
    this.userID,
    this.pageNumber,
    this.pageSize,
    this.totalRecords,
    this.firmwareType,
  });

  factory GetFirmwareVersionListData.fromJson(Map<String, dynamic> srcJson) =>
      _$GetFirmwareVersionListDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetFirmwareVersionListDataToJson(this);
}

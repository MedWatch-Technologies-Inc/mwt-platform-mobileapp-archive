import 'package:json_annotation/json_annotation.dart';

part 'get_preference_setting_result.g.dart';

@JsonSerializable()
class GetPreferenceSettingResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  Data? data;

  GetPreferenceSettingResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetPreferenceSettingResult.fromJson(Map<String, dynamic> srcJson) =>
      _$GetPreferenceSettingResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetPreferenceSettingResultToJson(this);
}

@JsonSerializable()
class Data extends Object {
  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'FileURL')
  String? fileURL;

  @JsonKey(name: 'CreatedDateTime')
  String? createdDateTime;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  Data({
    this.iD,
    this.userID,
    this.fileURL,
    this.createdDateTime,
    this.createdDateTimeStamp,
  });

  factory Data.fromJson(Map<String, dynamic> srcJson) =>
      _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

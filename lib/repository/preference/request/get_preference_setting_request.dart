import 'package:json_annotation/json_annotation.dart';

part 'get_preference_setting_request.g.dart';

@JsonSerializable()
class GetPreferenceSettingRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  GetPreferenceSettingRequest({
    this.userID,
  });

  factory GetPreferenceSettingRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$GetPreferenceSettingRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetPreferenceSettingRequestToJson(this);
}

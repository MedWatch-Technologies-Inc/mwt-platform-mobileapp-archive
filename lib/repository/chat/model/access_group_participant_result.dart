import 'package:json_annotation/json_annotation.dart';

part 'access_group_participant_result.g.dart';

@JsonSerializable()
class AccessGroupParticipantResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<AccessGroupParticipantData>? data;

  AccessGroupParticipantResult({
    this.result,
    this.response,
    this.data,
  });

  factory AccessGroupParticipantResult.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$AccessGroupParticipantResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$AccessGroupParticipantResultToJson(this);
}

@JsonSerializable()
class AccessGroupParticipantData extends Object {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'FirstName')
  String? firstName;

  @JsonKey(name: 'LastName')
  String? lastName;

  @JsonKey(name: 'UserName')
  String? userName;

  @JsonKey(name: 'IsActive')
  bool? isActive;

  @JsonKey(name: 'FullName')
  String? fullName;

  @JsonKey(name: 'UserImage')
  String? userImage;

  AccessGroupParticipantData(
      {this.id,
      this.userID,
      this.firstName,
      this.lastName,
      this.userName,
      this.isActive,
      this.fullName,
      this.userImage});

  factory AccessGroupParticipantData.fromJson(Map<String, dynamic> srcJson) =>
      _$AccessGroupParticipantDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccessGroupParticipantDataToJson(this);
}

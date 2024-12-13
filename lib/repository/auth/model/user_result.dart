import 'package:json_annotation/json_annotation.dart';

part 'user_result.g.dart';

@JsonSerializable()
class UserResult extends Object {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'DeviceID')
  int? deviceID;

  @JsonKey(name: 'FirstName')
  String? firstName;

  @JsonKey(name: 'LastName')
  String? lastName;

  @JsonKey(name: 'State')
  int? state;

  @JsonKey(name: 'Email')
  String? email;

  @JsonKey(name: 'IsActive')
  bool? isActive;

  @JsonKey(name: 'UserName')
  String? userName;

  @JsonKey(name: 'RoleisActive')
  bool? roleisActive;

  @JsonKey(name: 'GuIDIsActive')
  bool? guIDIsActive;

  @JsonKey(name: 'CountryID')
  int? countryID;

  @JsonKey(name: 'Picture')
  String? picture;

  @JsonKey(name: 'Gender')
  String? gender;

  @JsonKey(name: 'Height')
  String? height;

  @JsonKey(name: 'Weight')
  String? weight;

  @JsonKey(name: 'IsDelete')
  bool? isDelete;

  @JsonKey(name: 'RememberMe')
  bool? rememberMe;

  @JsonKey(name: 'UserRoleID')
  int? userRoleID;

  @JsonKey(name: 'DateOfBirth')
  String? dateOfBirth;

  @JsonKey(name: 'UserTypeID')
  int? userTypeID;

  @JsonKey(name: 'SkinType')
  String? skinType;

  @JsonKey(name: 'TotalRecords')
  int? totalRecords;

  @JsonKey(name: 'PageNumber')
  int? pageNumber;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'CompanyID')
  int? companyID;

  @JsonKey(name: 'UnitNameID')
  int? unitNameID;

  @JsonKey(name: 'CreateDateTime')
  String? createDateTime;

  @JsonKey(name: 'IsResearcherProfile')
  bool? isResearcherProfile;

  @JsonKey(name: 'InitialWeight')
  double? initialWeight;

  @JsonKey(name: 'IsConfirmed')
  bool? isConfirmed;

  @JsonKey(name: 'UserGroup')
  int? userGroup;

  @JsonKey(name: 'HeightUnit')
  int? heightUnit;

  @JsonKey(name: 'WeightUnit')
  int? weightUnit;

  @JsonKey(name: 'UserMeasurementTypeID')
  int? userMeasurementTypeID;

  @JsonKey(name: 'WUnit')
  int? wUnit;

  @JsonKey(name: 'DeviceToken')
  String? deviceToken;

  UserResult({
    this.id,
    this.userID,
    this.deviceID,
    this.firstName,
    this.lastName,
    this.state,
    this.email,
    this.isActive,
    this.userName,
    this.roleisActive,
    this.guIDIsActive,
    this.countryID,
    this.picture,
    this.gender,
    this.height,
    this.weight,
    this.isDelete,
    this.rememberMe,
    this.userRoleID,
    this.dateOfBirth,
    this.userTypeID,
    this.skinType,
    this.totalRecords,
    this.pageNumber,
    this.pageSize,
    this.companyID,
    this.unitNameID,
    this.createDateTime,
    this.isResearcherProfile,
    this.initialWeight,
    this.isConfirmed,
    this.userGroup,
    this.heightUnit,
    this.weightUnit,
    this.userMeasurementTypeID,
    this.wUnit,
    this.deviceToken,
  });

  factory UserResult.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('InitialWeight') &&
        srcJson['InitialWeight'] is String) {
      srcJson['InitialWeight'] = double.parse(srcJson['InitialWeight']);
    }
    return _$UserResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$UserResultToJson(this);
}

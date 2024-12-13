import 'package:json_annotation/json_annotation.dart';

part 'edit_user_request.g.dart';

@JsonSerializable()
class EditUserRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'FirstName')
  String? firstName;

  @JsonKey(name: 'LastName')
  String? lastName;

  @JsonKey(name: 'Gender')
  String? gender;

  @JsonKey(name: 'UnitID')
  int? unitID;

  @JsonKey(name: 'DateOfBirth')
  String? dateOfBirth;

  @JsonKey(name: 'Picture')
  String? picture;

  @JsonKey(name: 'Height')
  String? height;

  @JsonKey(name: 'Weight')
  String? weight;

  @JsonKey(name: 'InitialWeight')
  String? initialWeight;

  @JsonKey(name: 'SkinType')
  String? skinType;

  @JsonKey(name: 'IsResearcherProfile')
  bool? isResearcherProfile;

  @JsonKey(name: 'IsUpdate')
  bool? isUpdate;

  @JsonKey(name: 'UserImage')
  String? userImage;

  @JsonKey(name: 'UserMeasurementTypeID')
  int? userMeasurementTypeID;

  @JsonKey(name: 'WeightUnit')
  int? weightUnit;

  @JsonKey(name: 'HeightUnit')
  int? heightUnit;

  @JsonKey(name: 'BMI')
  double? bmi;


  EditUserRequest({
    this.userID,
    this.firstName,
    this.lastName,
    this.gender,
    this.unitID,
    this.dateOfBirth,
    this.picture,
    this.height,
    this.weight,
    this.initialWeight,
    this.skinType,
    this.isResearcherProfile,
    this.isUpdate,
    this.userImage,
    this.userMeasurementTypeID,
    this.weightUnit,
    this.heightUnit,
    this.bmi,
  });

  factory EditUserRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$EditUserRequestFromJson(srcJson);

  Map<String, dynamic> toJson() {
    var map = _$EditUserRequestToJson(this);
    map.removeWhere((key, value) => value == null);
    return map;
  }
}

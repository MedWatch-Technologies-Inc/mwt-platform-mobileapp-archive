import 'package:json_annotation/json_annotation.dart';

part 'user_registration_request.g.dart';

@JsonSerializable()
class UserRegistrationRequest extends Object {
  @JsonKey(name: 'FirstName')
  String? firstName;

  @JsonKey(name: 'LastName')
  String? lastName;

  @JsonKey(name: 'Email')
  String? email;

  @JsonKey(name: 'Gender')
  String? gender;

  @JsonKey(name: 'Phone')
  String? phone;

  @JsonKey(name: 'Password')
  String? password;

  @JsonKey(name: 'UserName')
  String? userName;

  @JsonKey(name: 'DateOfBirth')
  String? dateOfBirth;

  @JsonKey(name: 'UserGroup')
  int? userGroup;

  @JsonKey(name: 'Height')
  double? height;

  @JsonKey(name: 'Weight')
  double? weight;

  @JsonKey(name: 'InitialWeight')
  double? initialWeight;

  @JsonKey(name: 'DeviceToken')
  String? deviceToken;

  @JsonKey(name: 'UserMeasurementTypeID')
  int? userMeasurementTypeID;

  @JsonKey(name: 'WeightUnit')
  int? weightUnit;

  @JsonKey(name: 'HeightUnit')
  int? heightUnit;

  @JsonKey(name: 'CreatedDateTimeStamp')
  int? createdDateTimeStamp;

  UserRegistrationRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.password,
    this.userName,
    this.dateOfBirth,
    this.userGroup,
    this.height,
    this.weight,
    this.deviceToken,
    this.userMeasurementTypeID,
    this.weightUnit,
    this.heightUnit,
    this.createdDateTimeStamp,
    this.initialWeight,
  });

  factory UserRegistrationRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$UserRegistrationRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserRegistrationRequestToJson(this);
}

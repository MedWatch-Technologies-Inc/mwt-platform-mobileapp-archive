// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registration_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistrationRequest _$UserRegistrationRequestFromJson(Map json) =>
    UserRegistrationRequest(
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      email: json['Email'] as String?,
      gender: json['Gender'] as String?,
      // gender: 'M',
      phone: json['Phone'] as String?,
      password: json['Password'] as String?,
      userName: json['UserName'] as String?,
      dateOfBirth: json['DateOfBirth'] as String?,
      userGroup: json['UserGroup'] as int?,
      height: (json['Height'] as num?)?.toDouble(),
      weight: (json['Weight'] as num?)?.toDouble(),
      deviceToken: json['DeviceToken'] as String?,
      userMeasurementTypeID: json['UserMeasurementTypeID'] as int?,
      weightUnit: json['WeightUnit'] as int?,
      heightUnit: json['HeightUnit'] as int?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as int?,
      initialWeight: (json['InitialWeight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserRegistrationRequestToJson(
        UserRegistrationRequest instance) =>
    <String, dynamic>{
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'Email': instance.email,
      'Gender': instance.gender,
      'Phone': instance.phone,
      'Password': instance.password,
      'UserName': instance.userName,
      'DateOfBirth': instance.dateOfBirth,
      'UserGroup': instance.userGroup,
      'Height': instance.height,
      'Weight': instance.weight,
      'InitialWeight': instance.initialWeight,
      'DeviceToken': instance.deviceToken,
      'UserMeasurementTypeID': instance.userMeasurementTypeID,
      'WeightUnit': instance.weightUnit,
      'HeightUnit': instance.heightUnit,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditUserRequest _$EditUserRequestFromJson(Map json) => EditUserRequest(
      userID: json['UserID'] as String?,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      gender: json['Gender'] as String?,
      unitID: json['UnitID'] as int?,
      dateOfBirth: json['DateOfBirth'] as String?,
      picture: json['Picture'] as String?,
      height: json['Height'] as String?,
      weight: json['Weight'] as String?,
      initialWeight: json['InitialWeight'] as String?,
      skinType: json['SkinType'] as String?,
      isResearcherProfile: json['IsResearcherProfile'] as bool?,
      isUpdate: json['IsUpdate'] as bool?,
      userImage: json['UserImage'] as String?,
      userMeasurementTypeID: json['UserMeasurementTypeID'] as int?,
      weightUnit: json['WeightUnit'] as int?,
      heightUnit: json['HeightUnit'] as int?,
    );

Map<String, dynamic> _$EditUserRequestToJson(EditUserRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'Gender': instance.gender,
      'UnitID': instance.unitID,
      'DateOfBirth': instance.dateOfBirth,
      'Picture': instance.picture,
      'Height': instance.height,
      'Weight': instance.weight,
      'InitialWeight': instance.initialWeight,
      'SkinType': instance.skinType,
      'IsResearcherProfile': instance.isResearcherProfile,
      'IsUpdate': instance.isUpdate,
      'UserImage': instance.userImage,
      'UserMeasurementTypeID': instance.userMeasurementTypeID,
      'WeightUnit': instance.weightUnit,
      'HeightUnit': instance.heightUnit,
      'BMI': instance.bmi,
    };

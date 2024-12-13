// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_group_participant_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessGroupParticipantResult _$AccessGroupParticipantResultFromJson(Map json) =>
    AccessGroupParticipantResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => AccessGroupParticipantData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$AccessGroupParticipantResultToJson(
        AccessGroupParticipantResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

AccessGroupParticipantData _$AccessGroupParticipantDataFromJson(Map json) =>
    AccessGroupParticipantData(
      id: json['id'] as int?,
      userID: json['UserID'] as int?,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      userName: json['UserName'] as String?,
      isActive: json['IsActive'] as bool?,
      fullName: json['FullName'] as String?,
      userImage: json['UserImage'] as String?,
    );

Map<String, dynamic> _$AccessGroupParticipantDataToJson(
        AccessGroupParticipantData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'UserID': instance.userID,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'UserName': instance.userName,
      'IsActive': instance.isActive,
      'FullName': instance.fullName,
      'UserImage': instance.userImage,
    };

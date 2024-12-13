// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_chatted_with_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessChattedWithResult _$AccessChattedWithResultFromJson(Map json) =>
    AccessChattedWithResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => AccessChattedWithData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$AccessChattedWithResultToJson(
        AccessChattedWithResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

AccessChattedWithData _$AccessChattedWithDataFromJson(Map json) =>
    AccessChattedWithData(
      userID: json['UserID'] as int?,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      username: json['Username'] as String?,
      groupName: json['groupName'] as String?,
      toUserId: json['toUserId'] as int?,
      id: json['id'] as int?,
      isGroup: json['isGroup'] as int?,
      members: json['members'] as String?,
    );

Map<String, dynamic> _$AccessChattedWithDataToJson(
        AccessChattedWithData instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'Username': instance.username,
      'id': instance.id,
      'isGroup': instance.isGroup,
      'members': instance.members,
      'toUserId': instance.toUserId,
      'groupName': instance.groupName,
    };

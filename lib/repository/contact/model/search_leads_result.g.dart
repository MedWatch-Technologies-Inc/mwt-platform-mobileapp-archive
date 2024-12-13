// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_leads_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchLeadsResult _$SearchLeadsResultFromJson(Map json) => SearchLeadsResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) =>
              SearchLeadsData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$SearchLeadsResultToJson(SearchLeadsResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

SearchLeadsData _$SearchLeadsDataFromJson(Map json) => SearchLeadsData(
      userID: json['UserID'] as int?,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      picture: json['Picture'] as String?,
      email: json['Email'] as String?,
      phone: json['Phone'] as String?,
      userName: json['UserName'] as String?,
    );

Map<String, dynamic> _$SearchLeadsDataToJson(SearchLeadsData instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'Picture': instance.picture,
      'Email': instance.email,
      'Phone': instance.phone,
      'UserName': instance.userName,
    };

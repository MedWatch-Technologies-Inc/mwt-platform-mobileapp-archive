// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_preference_setting_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPreferenceSettingResult _$GetPreferenceSettingResultFromJson(Map json) =>
    GetPreferenceSettingResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: json['Data'] == null
          ? null
          : Data.fromJson(Map<String, dynamic>.from(json['Data'] as Map)),
    );

Map<String, dynamic> _$GetPreferenceSettingResultToJson(
        GetPreferenceSettingResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.toJson(),
    };

Data _$DataFromJson(Map json) => Data(
      iD: json['ID'] as int?,
      userID: json['UserID'] as int?,
      fileURL: json['FileURL'] as String?,
      createdDateTime: json['CreatedDateTime'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'ID': instance.iD,
      'UserID': instance.userID,
      'FileURL': instance.fileURL,
      'CreatedDateTime': instance.createdDateTime,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_hr_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHrDataResponse _$GetHrDataResponseFromJson(Map json) => GetHrDataResponse(
      json['Result'] as bool,
      json['Response'] as int,
      (json['Data'] is List ) ? (json['Data'] as  List<dynamic>)
          .map((e) => HrDataModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList() : [],
    );

Map<String, dynamic> _$GetHrDataResponseToJson(GetHrDataResponse instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.hrData.map((e) => e.toJson()).toList(),
    };

HrDataModel _$HrDataModelFromJson(Map json) => HrDataModel(
      apiId: json['ID'] as int?,
      userId: json['userId'] as int?,
      date: json['date'] as String?,
      hr: json['hr'] as int?,
      id: json['id'] as int?,
      zoneID : json['ZoneID'] as int?
    );

Map<String, dynamic> _$HrDataModelToJson(HrDataModel instance) =>
    <String, dynamic>{
      'ID': instance.apiId,
      'userId': instance.userId,
      'date': instance.date,
      'hr': instance.hr,
      'id': instance.id,
      'ZoneID': instance.zoneID
    };

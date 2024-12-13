// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_third_party_data_type_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveThirdPartyDataTypeResult _$SaveThirdPartyDataTypeResultFromJson(Map json) =>
    SaveThirdPartyDataTypeResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$SaveThirdPartyDataTypeResultToJson(
        SaveThirdPartyDataTypeResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };

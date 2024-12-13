// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_tag_label_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddTagLabelResult _$AddTagLabelResultFromJson(Map json) => AddTagLabelResult(
      result: json['Result'] as bool?,
      message: json['Message'] as String?,
      iD: json['ID'] as int?,
    )..response = json['Response'] as int?;

Map<String, dynamic> _$AddTagLabelResultToJson(AddTagLabelResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
      'ID': instance.iD,
    };

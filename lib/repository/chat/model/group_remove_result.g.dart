// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_remove_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupRemoveResult _$GroupRemoveResultFromJson(Map json) => GroupRemoveResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$GroupRemoveResultToJson(GroupRemoveResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_exist_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserExistResult _$UserExistResultFromJson(Map json) => UserExistResult(
      json['Result'] as bool,
      json['Message'] as String,
    );

Map<String, dynamic> _$UserExistResultToJson(UserExistResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Message': instance.message,
    };

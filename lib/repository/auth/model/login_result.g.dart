// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResult _$LoginResultFromJson(Map json) => LoginResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      iD: json['ID'] as int?,
      message: json['Message'] as String?,
      data: json['Data'] == null
          ? null
          : UserResult.fromJson(Map<String, dynamic>.from(json['Data'] as Map)),
      salt: json['Salt'] as String?,
      errors: json['Errors'] as List<dynamic>?,
    );

Map<String, dynamic> _$LoginResultToJson(LoginResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'ID': instance.iD,
      'Message': instance.message,
      'Salt': instance.salt,
      'Data': instance.data?.toJson(),
      'Errors': instance.errors,
    };

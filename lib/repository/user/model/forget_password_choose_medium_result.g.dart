// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_password_choose_medium_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgetPasswordChooseMediumResult _$ForgetPasswordChooseMediumResultFromJson(
        Map json) =>
    ForgetPasswordChooseMediumResult(
      result: json['Result'] as bool?,
      iD: json['ID'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$ForgetPasswordChooseMediumResultToJson(
        ForgetPasswordChooseMediumResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'ID': instance.iD,
      'Message': instance.message,
    };

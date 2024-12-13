// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_password_choose_medium_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgetPasswordChooseMediumRequest _$ForgetPasswordChooseMediumRequestFromJson(
        Map json) =>
    ForgetPasswordChooseMediumRequest(
      userName: json['UserName'] as String?,
      isPhone: json['isPhone'] as bool?,
    );

Map<String, dynamic> _$ForgetPasswordChooseMediumRequestToJson(
        ForgetPasswordChooseMediumRequest instance) =>
    <String, dynamic>{
      'UserName': instance.userName,
      'isPhone': instance.isPhone,
    };

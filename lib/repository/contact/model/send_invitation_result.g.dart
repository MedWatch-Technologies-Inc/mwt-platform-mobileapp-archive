// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_invitation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendInvitationResult _$SendInvitationResultFromJson(Map json) =>
    SendInvitationResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$SendInvitationResultToJson(
        SendInvitationResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_or_reject_invitation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptOrRejectInvitationResult _$AcceptOrRejectInvitationResultFromJson(
        Map json) =>
    AcceptOrRejectInvitationResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$AcceptOrRejectInvitationResultToJson(
        AcceptOrRejectInvitationResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };

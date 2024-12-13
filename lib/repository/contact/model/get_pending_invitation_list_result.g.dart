// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_pending_invitation_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPendingInvitationListResult _$GetPendingInvitationListResultFromJson(
        Map json) =>
    GetPendingInvitationListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => GetPendingInvitationListData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GetPendingInvitationListResultToJson(
        GetPendingInvitationListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

GetPendingInvitationListData _$GetPendingInvitationListDataFromJson(Map json) =>
    GetPendingInvitationListData(
      contactID: json['ContactID'] as int?,
      senderUserID: json['SenderUserID'] as int?,
      senderFirstName: json['SenderFirstName'] as String?,
      senderLastName: json['SenderLastName'] as String?,
      senderEmail: json['SenderEmail'] as String?,
      senderPhone: json['SenderPhone'] as String?,
      senderPicture: json['SenderPicture'] as String?,
      senderUserName: json['SenderUserName'] as String?,
    );

Map<String, dynamic> _$GetPendingInvitationListDataToJson(
        GetPendingInvitationListData instance) =>
    <String, dynamic>{
      'ContactID': instance.contactID,
      'SenderUserID': instance.senderUserID,
      'SenderFirstName': instance.senderFirstName,
      'SenderLastName': instance.senderLastName,
      'SenderEmail': instance.senderEmail,
      'SenderPhone': instance.senderPhone,
      'SenderPicture': instance.senderPicture,
      'SenderUserName': instance.senderUserName,
    };

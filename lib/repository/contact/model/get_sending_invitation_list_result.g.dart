// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_sending_invitation_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSendingInvitationListResult _$GetSendingInvitationListResultFromJson(
        Map json) =>
    GetSendingInvitationListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => GetSendingInvitationListData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GetSendingInvitationListResultToJson(
        GetSendingInvitationListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

GetSendingInvitationListData _$GetSendingInvitationListDataFromJson(Map json) =>
    GetSendingInvitationListData(
      iD: json['ID'] as int?,
      userID: json['UserID'] as int?,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      picture: json['Picture'] as String?,
      createdDatetime: json['CreatedDatetime'] as String?,
      receiverEmail: json['ReceiverEmail'] as String?,
      receiverPhone: json['ReceiverPhone'] as String?,
    );

Map<String, dynamic> _$GetSendingInvitationListDataToJson(
        GetSendingInvitationListData instance) =>
    <String, dynamic>{
      'ID': instance.iD,
      'UserID': instance.userID,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'Picture': instance.picture,
      'CreatedDatetime': instance.createdDatetime,
      'ReceiverEmail': instance.receiverEmail,
      'ReceiverPhone': instance.receiverPhone,
    };

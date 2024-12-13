// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_contact_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetContactListResult _$GetContactListResultFromJson(Map json) =>
    GetContactListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) =>
              GetContactListData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    )..isFromDb = json['isFromDb'] as bool?;

Map<String, dynamic> _$GetContactListResultToJson(
        GetContactListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
      'isFromDb': instance.isFromDb,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

GetContactListData _$GetContactListDataFromJson(Map json) => GetContactListData(
      contactID: json['ContactID'] as int?,
      senderUserID: json['SenderUserID'] as int?,
      receiverUserID: json['ReceiverUserID'] as int?,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      email: json['Email'] as String?,
      phone: json['Phone'] as String?,
      username: json['Username'] as String?,
      picture: json['Picture'] as String?,
      isAccepted: json['IsAccepted'] as bool?,
      createdDatetime: json['CreatedDatetime'] as String?,
      acceptedDate: json['AcceptedDate'] as String?,
    );

Map<String, dynamic> _$GetContactListDataToJson(GetContactListData instance) =>
    <String, dynamic>{
      'ContactID': instance.contactID,
      'SenderUserID': instance.senderUserID,
      'ReceiverUserID': instance.receiverUserID,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'Email': instance.email,
      'Phone': instance.phone,
      'Username': instance.username,
      'Picture': instance.picture,
      'IsAccepted': instance.isAccepted,
      'CreatedDatetime': instance.createdDatetime,
      'AcceptedDate': instance.acceptedDate,
    };

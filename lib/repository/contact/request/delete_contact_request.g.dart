// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_contact_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteContactRequest _$DeleteContactRequestFromJson(Map json) =>
    DeleteContactRequest(
      contactFromUserID: json['ContactFromUserID'] as String?,
      contactToUserId: json['ContactToUserId'] as String?,
    );

Map<String, dynamic> _$DeleteContactRequestToJson(
        DeleteContactRequest instance) =>
    <String, dynamic>{
      'ContactFromUserID': instance.contactFromUserID,
      'ContactToUserId': instance.contactToUserId,
    };

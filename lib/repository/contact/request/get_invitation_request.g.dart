// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_invitation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInvitationRequest _$GetInvitationRequestFromJson(Map json) =>
    GetInvitationRequest(
      loggedInUserId: json['LoggedinUserID'] as int?,
      pageIndex: json['SearchKey'] as String?,
      iDs: json['IDs'] as List<dynamic>?,
    );

Map<String, dynamic> _$GetInvitationRequestToJson(
        GetInvitationRequest instance) =>
    <String, dynamic>{
      'LoggedinUserID': instance.loggedInUserId,
      'SearchKey': instance.pageIndex,
      'IDs': instance.iDs,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_invitation_list_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInvitationListEventRequest _$GetInvitationListEventRequestFromJson(
        Map json) =>
    GetInvitationListEventRequest(
      userID: json['UserID'] as int?,
      pageIndex: json['PageIndex'] as int?,
      pageSize: json['PageSize'] as int?,
      iDs: json['IDs'] as List<dynamic>?,
    );

Map<String, dynamic> _$GetInvitationListEventRequestToJson(
        GetInvitationListEventRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'PageIndex': instance.pageIndex,
      'PageSize': instance.pageSize,
      'IDs': instance.iDs,
    };

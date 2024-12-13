// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_list_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListEventRequest _$GetListEventRequestFromJson(Map json) =>
    GetListEventRequest(
      userID: json['UserID'] as int?,
      pageSize: json['pageSize'] as int?,
      pageNumber: json['pageNumber'] as int?,
      messageTypeId: json['MessageTypeid'] as int?,
    );

Map<String, dynamic> _$GetListEventRequestToJson(
        GetListEventRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'pageSize': instance.pageSize,
      'pageNumber': instance.pageNumber,
      'MessageTypeid': instance.messageTypeId,
    };

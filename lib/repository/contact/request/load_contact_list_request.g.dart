// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_contact_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadContactListRequest _$LoadContactListRequestFromJson(Map json) =>
    LoadContactListRequest(
      userID: json['UserID'] as String?,
      pageIndex: json['PageIndex'] as int?,
      pageSize: json['PageSize'] as int?,
      iDs: json['IDs'] as List<dynamic>?,
      // fromDateStamp: json['FromDateStamp'] as String?,
      // toDateStamp: json['ToDateStamp'] as String?,
    );

Map<String, dynamic> _$LoadContactListRequestToJson(
        LoadContactListRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'PageIndex': instance.pageIndex,
      'PageSize': instance.pageSize,
      'IDs': instance.iDs,
      // 'FromDateStamp': instance.fromDateStamp,
      // 'ToDateStamp': instance.toDateStamp,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_shared_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteSharedEventRequest _$DeleteSharedEventRequestFromJson(Map json) =>
    DeleteSharedEventRequest(
      json['UserID'] as String?,
      json['LibraryID'] as String?,
    );

Map<String, dynamic> _$DeleteSharedEventRequestToJson(
        DeleteSharedEventRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'LibraryID': instance.libraryID,
    };

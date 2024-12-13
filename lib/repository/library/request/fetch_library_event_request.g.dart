// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_library_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchLibraryEventRequest _$FetchLibraryEventRequestFromJson(Map json) =>
    FetchLibraryEventRequest(
      userID: json['UserID'] as String?,
      libraryID: json['LibraryID'] as String?,
    );

Map<String, dynamic> _$FetchLibraryEventRequestToJson(
        FetchLibraryEventRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'LibraryID': instance.libraryID,
    };

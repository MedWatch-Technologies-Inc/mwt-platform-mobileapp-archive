// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_contact_list_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchContactListEventRequest _$SearchContactListEventRequestFromJson(
        Map json) =>
    SearchContactListEventRequest(
      loggedInUserID: json['LoggedinUserID'] as String?,
      searchText: json['SearchText'] as String?,
    );

Map<String, dynamic> _$SearchContactListEventRequestToJson(
        SearchContactListEventRequest instance) =>
    <String, dynamic>{
      'LoggedinUserID': instance.loggedInUserID,
      'SearchText': instance.searchText,
    };

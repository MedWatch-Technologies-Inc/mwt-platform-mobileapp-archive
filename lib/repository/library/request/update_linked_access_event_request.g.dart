// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_linked_access_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateLinkedAccessEventRequest _$UpdateLinkedAccessEventRequestFromJson(
        Map json) =>
    UpdateLinkedAccessEventRequest(
      userID: json['UserID'] as int?,
      fKLirabaryID: json['FKLirabaryID'] as int?,
      optionCopyLinkAccess: json['OptionCopyLinkAccess'] as int?,
    );

Map<String, dynamic> _$UpdateLinkedAccessEventRequestToJson(
        UpdateLinkedAccessEventRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'FKLirabaryID': instance.fKLirabaryID,
      'OptionCopyLinkAccess': instance.optionCopyLinkAccess,
    };

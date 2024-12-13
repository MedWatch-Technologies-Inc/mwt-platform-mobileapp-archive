// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_trash_message_delete_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipleTrashMessageDeleteEventRequest
    _$MultipleTrashMessageDeleteEventRequestFromJson(Map json) =>
        MultipleTrashMessageDeleteEventRequest(
          messagesIds: (json['MessagesIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList(),
        );

Map<String, dynamic> _$MultipleTrashMessageDeleteEventRequestToJson(
        MultipleTrashMessageDeleteEventRequest instance) =>
    <String, dynamic>{
      'MessagesIds': instance.messagesIds,
    };

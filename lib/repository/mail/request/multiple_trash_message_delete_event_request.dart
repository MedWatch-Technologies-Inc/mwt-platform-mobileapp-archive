import 'package:json_annotation/json_annotation.dart';

part 'multiple_trash_message_delete_event_request.g.dart';

@JsonSerializable()
class MultipleTrashMessageDeleteEventRequest extends Object {
  @JsonKey(name: 'MessagesIds')
  List<int>? messagesIds;

  MultipleTrashMessageDeleteEventRequest({
    this.messagesIds,
  });

  factory MultipleTrashMessageDeleteEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$MultipleTrashMessageDeleteEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$MultipleTrashMessageDeleteEventRequestToJson(this);
}

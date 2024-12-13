import 'package:json_annotation/json_annotation.dart';

part 'group_remove_event_request.g.dart';

@JsonSerializable()
class GroupRemoveEventRequest extends Object {
  @JsonKey(name: 'groupName')
  String? groupName;

  GroupRemoveEventRequest({
    this.groupName,
  });

  factory GroupRemoveEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$GroupRemoveEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GroupRemoveEventRequestToJson(this);
}

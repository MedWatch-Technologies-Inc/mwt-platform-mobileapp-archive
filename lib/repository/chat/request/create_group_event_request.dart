import 'package:json_annotation/json_annotation.dart';

part 'create_group_event_request.g.dart';

@JsonSerializable()
class CreateGroupEventRequest extends Object {
  @JsonKey(name: 'groupName')
  String? groupName;

  @JsonKey(name: 'memberIds')
  String? memberIds;

  CreateGroupEventRequest({
    this.groupName,
    this.memberIds,
  });

  factory CreateGroupEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$CreateGroupEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CreateGroupEventRequestToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'group_listing_event_request.g.dart';

@JsonSerializable()
class GroupListingEventRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  GroupListingEventRequest({
    this.userID,
  });

  factory GroupListingEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$GroupListingEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GroupListingEventRequestToJson(this);
}

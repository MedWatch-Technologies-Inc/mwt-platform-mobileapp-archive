import 'package:json_annotation/json_annotation.dart';

part 'get_invitation_list_event_request.g.dart';

@JsonSerializable()
class GetInvitationListEventRequest extends Object {
  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'PageIndex')
  int? pageIndex;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'IDs')
  List<dynamic>? iDs;

  GetInvitationListEventRequest({
    this.userID,
    this.pageIndex,
    this.pageSize,
    this.iDs,
  });

  factory GetInvitationListEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetInvitationListEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetInvitationListEventRequestToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'get_invitation_request.g.dart';

@JsonSerializable()
class GetInvitationRequest extends Object {
  @JsonKey(name: 'LoggedinUserID')
  int? loggedInUserId;

  @JsonKey(name: 'SearchKey')
  String? pageIndex;

  @JsonKey(name: 'IDs')
  List<dynamic>? iDs;

  GetInvitationRequest({
    this.loggedInUserId,
    this.pageIndex,
    this.iDs,
  });

  factory GetInvitationRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$GetInvitationRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetInvitationRequestToJson(this);
}

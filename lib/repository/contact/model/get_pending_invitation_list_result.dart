import 'package:json_annotation/json_annotation.dart';

part 'get_pending_invitation_list_result.g.dart';

@JsonSerializable()
class GetPendingInvitationListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<GetPendingInvitationListData>? data;

  GetPendingInvitationListResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetPendingInvitationListResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetPendingInvitationListResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetPendingInvitationListResultToJson(this);
}

@JsonSerializable()
class GetPendingInvitationListData extends Object {
  @JsonKey(name: 'ContactID')
  int? contactID;

  @JsonKey(name: 'SenderUserID')
  int? senderUserID;

  @JsonKey(name: 'SenderFirstName')
  String? senderFirstName;

  @JsonKey(name: 'SenderLastName')
  String? senderLastName;

  @JsonKey(name: 'SenderEmail')
  String? senderEmail;

  @JsonKey(name: 'SenderPhone')
  String? senderPhone;

  @JsonKey(name: 'SenderPicture')
  String? senderPicture;

  @JsonKey(name: 'SenderUserName')
  String? senderUserName;

  GetPendingInvitationListData({
    this.contactID,
    this.senderUserID,
    this.senderFirstName,
    this.senderLastName,
    this.senderEmail,
    this.senderPhone,
    this.senderPicture,
    this.senderUserName,
  });

  factory GetPendingInvitationListData.fromJson(Map<String, dynamic> srcJson) =>
      _$GetPendingInvitationListDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetPendingInvitationListDataToJson(this);
}
